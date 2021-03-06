//
//  NewBillViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "NewOrEditBillViewController.h"
#import "OBMapPickerViewController.h"
#import  "CategoryView.h"
#import  "InoutSwitchButton.h"
#import  "BillValueInputView.h"
#import  "OBCategoryScrollView.h"
#import  "OBBillManager.h"
#import  "OBCategoryManager.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED>=110000
#define OBMas_top self.topLayoutGuide
#else
#define OBMas_top self.view.mas_top
#endif

@interface NewOrEditBillViewController () <UITextFieldDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) OBCategoryScrollView * categoryScrollView;
@property (nonatomic, strong) BillValueInputView * inputView;
@property (nonatomic, strong) OBCategoryManager * categoryManager;
@property (nonatomic, strong) InoutSwitchButton * inoutSwitchButton;
@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UITextField * dateLabel;
@property (nonatomic, strong) UIView * predictView;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder * geoCoder;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSMutableString * locDescription;
@property (nonatomic, strong) NSString * revokeCategory;
@property double revokeValue;
//about edit mode
@property BOOL editMode;
@property (nonatomic, strong) OBBill * editModeOldBill;

@end

@implementation NewOrEditBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取分类
    self.categoryManager=[OBCategoryManager sharedInstance];
    [self addObserver:self forKeyPath:@"categoryScrollView.currentCategory" options:NSKeyValueObservingOptionNew context:nil];
    [self setUI];
    //确认按钮随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //为撤回保存值
    self.revokeValue=0;
    self.revokeCategory=self.categoryManager.categoriesArr[0];
    if (!self.editMode) {//非edit状态
        [self initializeLocationService];
    } else {//edit状态填入已有值
        [self setEditModeUI];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"categoryScrollView.currentCategory"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUI {
    double screenHeightAdaptRatio=[UIScreen mainScreen].bounds.size.height/667.0;
    //设置导航栏返回按钮
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"Add New Bill";
    UIBarButtonItem * returnBarButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnButton"] style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonClicked)];
    self.navigationItem.leftBarButtonItem=returnBarButton;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.locDescription=[[NSMutableString alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.categoryScrollView=[[OBCategoryScrollView alloc] initWithCategorys:self.categoryManager.categoriesArr];
    [self.view addSubview:self.categoryScrollView];
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.top.equalTo(self.view.mas_top).with.offset(97*screenHeightAdaptRatio);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(88));
    }];
    self.inputView=[[BillValueInputView alloc] init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(self.view.mas_left).with.offset(75);
        make.right.equalTo(self.view.mas_right).with.offset(-55);
        make.top.equalTo(self.categoryScrollView.mas_bottom).with.offset(24*screenHeightAdaptRatio);
        make.height.equalTo(@(76));
    }];
    self.inputView.delegate=self;
    self.inoutSwitchButton=[[InoutSwitchButton alloc] init];
    [self.view addSubview:self.inoutSwitchButton];
    [self.inoutSwitchButton mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(49*screenHeightAdaptRatio);
        make.width.equalTo(@(120));
        make.height.equalTo(@(34));

    }];
    UIView * separateLine=[[UIView alloc] init];
    separateLine.backgroundColor=[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:0.3];
    [self.view addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker * make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-242.5*screenHeightAdaptRatio);
        make.height.equalTo(@(1));
        make.left.equalTo(self.view.mas_left).with.offset(70.5);
        make.right.equalTo(self.view.mas_right).with.offset(-50.5);
    }];
    self.confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [self.confirmButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-81, [UIScreen mainScreen].bounds.size.height-103, 60, 60)];
    self.confirmButton.backgroundColor=[UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1];
    self.confirmButton.layer.cornerRadius=10.f;
    self.confirmButton.layer.shadowColor=[UIColor grayColor].CGColor;
    self.confirmButton.layer.shadowOffset=CGSizeMake(0, 5);
    self.confirmButton.layer.shadowOpacity=0.1;
    self.confirmButton.layer.shadowRadius=3;
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.confirmButton.bounds cornerRadius:10.f];
    self.confirmButton.layer.shadowPath=shadowPath.CGPath;
    [self.view addSubview:self.confirmButton];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //地理位置
    UIView * locationView=[[UIView alloc] init];
    locationView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:locationView];
    [locationView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(separateLine.mas_left);
        make.top.equalTo(separateLine.mas_top).with.offset(26.5*screenHeightAdaptRatio);
        make.right.equalTo(separateLine.mas_right).with.offset(-10);
        make.height.equalTo(@(34));
    }];
    UIImageView * locationIconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon"]];
    [locationView addSubview:locationIconView];
    [locationIconView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(locationView.mas_left);
        make.centerY.equalTo(locationView.mas_centerY);
        make.width.equalTo(@(15));
        make.height.equalTo(@(20));
    }];
    self.locationLabel=[[UILabel alloc] init];
    [self.locationLabel setTextColor:[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]];
    [self.locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
    [self.locationLabel setNumberOfLines:2];
    self.locationLabel.text=@"Getting Location Information...";
    [locationView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(locationIconView.mas_right).with.offset(25);
        make.centerY.equalTo(locationView.mas_centerY);
        make.right.equalTo(locationView.mas_right);
        make.height.equalTo(@(34));
    }];
    UIButton * locationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton addTarget:self action:@selector(locationLabelTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    [locationButton mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(self.locationLabel.mas_left);
        make.right.equalTo(self.locationLabel.mas_right);
        make.top.equalTo(self.locationLabel.mas_top);
        make.bottom.equalTo(self.locationLabel.mas_bottom);
    }];
    //时间信息
    UIView * dateView=[[UIView alloc] init];
    dateView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(separateLine.mas_left);
        make.top.equalTo(locationView.mas_bottom).with.offset(37*screenHeightAdaptRatio);
        make.right.equalTo(separateLine.mas_right).with.offset(-40);
        make.height.equalTo(@(20));
    }];
    UIImageView * dateIconView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateIcon"]];
    [dateView addSubview:dateIconView];
    [dateIconView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(dateView.mas_left);
        make.centerY.equalTo(dateView.mas_centerY);
        make.width.equalTo(@(18));
        make.height.equalTo(@(18));
    }];
    self.dateLabel=[[UITextField alloc] init];
    [self.dateLabel setTextColor:[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]];
    [self.dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
    [dateView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(dateIconView.mas_right).with.offset(25);
        make.centerY.equalTo(dateView.mas_centerY);
        make.right.equalTo(dateView.mas_right);
        make.height.equalTo(@(17));
    }];
    //当前时间
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"HH:mm, MMM d";
    self.date=[NSDate date];
    NSString * dateString=[dateFormatter stringFromDate:self.date];
    self.dateLabel.text=dateString;
    UIDatePicker * datePicker=[[UIDatePicker alloc] init];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    datePicker.locale=[NSLocale localeWithLocaleIdentifier:@"us"];
    [datePicker addTarget:self action:@selector(selectedDateChange:) forControlEvents:UIControlEventValueChanged];
    self.dateLabel.inputView=datePicker;
    //预测成功弹出浮动窗
    self.predictView=[[UIView alloc] init];
    self.predictView.backgroundColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.05];
    self.predictView.layer.cornerRadius=10.f;
    self.predictView.alpha=0;
    [self.view addSubview:self.predictView];
    [self.predictView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(self.view.mas_left).with.offset(25);
        make.right.equalTo(self.view.mas_right).with.offset(-25);
        make.bottom.equalTo(self.categoryScrollView.mas_top).with.offset(-5*screenHeightAdaptRatio);
        make.height.equalTo(@(32));
    }];
    UILabel * predictLabel=[[UILabel alloc] init];
    predictLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:12];
    predictLabel.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1];
    predictLabel.text=@"Predicted for you already.";
    [self.predictView addSubview:predictLabel];
    [predictLabel mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(self.predictView.mas_left).with.offset(25);
        make.centerY.equalTo(self.predictView.mas_centerY);
    }];
    UIButton * revokeButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [revokeButton setTitle:@"Revoke" forState:UIControlStateNormal];
    [revokeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [revokeButton setTintColor:[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]];
    [revokeButton addTarget:self action:@selector(revokePrediction) forControlEvents:UIControlEventTouchUpInside];
    [self.predictView addSubview:revokeButton];
    [revokeButton mas_makeConstraints:^(MASConstraintMaker * make) {
        make.right.equalTo(self.predictView.mas_right).with.offset(-25);
        make.centerY.equalTo(self.predictView.mas_centerY);
        make.height.equalTo(@(14));
    }];
}

- (void)editModeWithBill:(OBBill *)bill {
    self.editMode=YES;
    self.editModeOldBill=bill;
}

- (void)setEditModeUI {
    self.title=@"Editing Bill";
    [self.categoryScrollView setHighlightCategory:self.editModeOldBill.category];
    self.inputView.text=[NSString stringWithFormat:@"%.2lf", self.editModeOldBill.value];
    self.inputView.isEdited=YES;
    self.editModeOldBill.isOut ? [self.inoutSwitchButton chooseOut] : [self.inoutSwitchButton chooseIn];
    self.date=self.editModeOldBill.date;
    self.location=self.editModeOldBill.location;
}

#pragma mark - dateLabel

- (void)setDate:(NSDate *)date {
    _date=date;
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"HH:mm, MMM d";
    NSString * dateString=[dateFormatter stringFromDate:date];
    self.dateLabel.text=dateString;
    UIDatePicker * datePicker=(UIDatePicker *) self.dateLabel.inputView;
    datePicker.date=date;
}

- (void)selectedDateChange:(UIDatePicker *)datePicker {
    self.date=datePicker.date;
}

#pragma mark - location service

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager=[[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=CLLocationDistanceMax;
    _locationManager.pausesLocationUpdatesAutomatically=YES;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.location=locations.lastObject;
    [manager stopUpdatingLocation];
    //预测category
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString * predictCategory=[[OBBillManager sharedInstance] predictCategoryWithDate:self.date Location:self.location];
        if (predictCategory!=nil) {
            double predictValue=[[OBBillManager sharedInstance] predictValueWithCategory:predictCategory Date:self.date AndLocation:self.location];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self showPredictView];
                [self.categoryScrollView setHighlightCategory:predictCategory];
                if (predictValue>0) {
                    self.inputView.textField.text=[NSString stringWithFormat:@"%.2lf", predictValue];
                    self.inputView.isEdited=YES;
                    self.inputView.isDecimalEdited=NO;
                }
            });
        }
    });
}

//懒加载初始化地理编码器
- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder=[[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (void)setLocation:(CLLocation *)location {
    _location=location;
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark * placemark=[placemarks objectAtIndex:0];
            NSMutableString * locStr=[[NSMutableString alloc] init];
            //获取市,省
            placemark.locality ? [locStr appendString:placemark.locality] : nil;
            locStr.length>0 ? [locStr appendString:@","] : nil;
            placemark.administrativeArea ? [locStr appendString:placemark.administrativeArea] : nil;
            locStr.length>0 ? [locStr appendString:@"\n"] : nil;
            // 位置名
//            [self.locDescription appendFormat:@"%@,%@",placemark.name,placemark.thoroughfare];
            if ([placemark.addressDictionary objectForKey:@"FormattedAddressLines"]) {
                NSArray * lines=[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
                lines.count ? self.locDescription=lines[0] : nil;
            }
//            [self.locDescription appendString:[placemark.addressDictionary objectForKey:@"FormattedAddressLines"][0]];
            [locStr appendString:self.locDescription];
            self.locationLabel.text=locStr;
        } else if (error==nil && [placemarks count]==0) {
            self.locationLabel.text=@"No Location Information";
        } else if (error!=nil) {
            self.locationLabel.text=@"An error occurred";
        }
    }];
}

- (void)locationLabelTaped {
    OBMapPickerViewController * mapVC=[[OBMapPickerViewController alloc] init];
    mapVC.location=self.location;
    mapVC.locationPickDoneHandler=^(CLLocation * _Nonnull location) {
        self.location=location;
    };
    UINavigationController * mapVCWrapperVC=[[UINavigationController alloc] initWithRootViewController:mapVC];
    [self presentViewController:mapVCWrapperVC animated:YES completion:nil];
}

#pragma mark - edit value

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
    if ([self.dateLabel isFirstResponder]) {
        [self.dateLabel resignFirstResponder];
    }
    if ([self.categoryScrollView.addTextField isFirstResponder]) {
        [self.categoryScrollView.addTextField resignFirstResponder];
    }
}

//弹出键盘时
- (void)keyboardWillChange:(NSNotification *)notification {
    if (!self.confirmed) {
        NSDictionary * userInfo=[notification userInfo];
        NSValue * value=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect=[value CGRectValue];
        CGRect frame=self.confirmButton.frame;
        frame.origin.y=keyboardRect.origin.y-frame.size.height-33;
        self.confirmButton.frame=frame;
    }
}

#pragma mark - about textField

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!self.inputView.isEdited) {
        [self.inputView makeTextCursorToIndex:0];
    } else if (!self.inputView.isDecimalEdited) {
        NSInteger indexOfPoint=[self.inputView.text rangeOfString:@"."].location;
        [self.inputView makeTextCursorToIndex:indexOfPoint];
    }
    [self.inputView enActived];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.inputView deActived];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isPressedBackspaceAfterSingleSpaceSymbol=[string isEqualToString:@""] && range.length==1;
    NSInteger indexOfPoint=[self.inputView.text rangeOfString:@"."].location;
    if (range.location>indexOfPoint) {
        self.inputView.isEdited=YES;
    }
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        if (range.location>=indexOfPoint) {
            NSInteger offsetAfterPoint=range.location-indexOfPoint;
            if (offsetAfterPoint==0) {
                [self.inputView makeTextCursorToIndex:indexOfPoint];
            } else {
                self.inputView.text=[self.inputView.text stringByReplacingCharactersInRange:range withString:@"0"];
                [self.inputView makeTextCursorToIndex:range.location];
            }
            return NO;
        }
    } else {
        if (!self.inputView.isEdited) {
            self.inputView.text=[string stringByAppendingString:@".00"];
            self.inputView.isEdited=YES;
            [self.inputView makeTextCursorToIndex:indexOfPoint];
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            [self.inputView makeTextCursorToIndex:indexOfPoint+1];
            return NO;
        } else if (range.location>indexOfPoint) {
            NSInteger offsetAfterPoint=range.location-indexOfPoint;
            self.inputView.isDecimalEdited=YES;
            if (offsetAfterPoint<=2) {
                self.inputView.text=[self.inputView.text stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:string];
                [self.inputView makeTextCursorToIndex:range.location+1];
            }
            return NO;
        }
    }
    if (self.inputView.text.length>11 && !isPressedBackspaceAfterSingleSpaceSymbol) return NO;
    else return YES;
}


- (void)confirmButtonClicked {
    self.confirmed=YES;
    if (self.editMode) {
        OBBill * newBill=[[OBBill alloc] initWithValue:self.inputView.text.doubleValue Date:self.date Location:self.location AndLocationDescription:self.locDescription Category:self.categoryScrollView.selectedView.label.text andIsOut:self.inoutSwitchButton.isOut];
        [[OBBillManager sharedInstance] editBillOfDate:self.editModeOldBill.date Value:self.editModeOldBill.value withBill:newBill];
        [[OBBillManager sharedInstance] updateSumOfDay:newBill.date];
        [[OBBillManager sharedInstance] updateSumOfDay:self.editModeOldBill.date];
        self.editCompletedHandler();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        OBBill * bill=[[OBBill alloc] initWithValue:self.inputView.text.doubleValue Date:self.date Location:self.location AndLocationDescription:self.locDescription Category:self.categoryScrollView.selectedView.label.text andIsOut:self.inoutSwitchButton.isOut];
        [[OBBillManager sharedInstance] insertBill:bill];
        [[OBBillManager sharedInstance] updateSumOfDay:bill.date];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - prediction

- (void)revokePrediction {
    self.inputView.textField.text=[NSString stringWithFormat:@"%.2lf", self.revokeValue];
    self.inputView.isEdited=self.revokeValue!=0;
    self.inputView.isDecimalEdited=NO;
    [self.categoryScrollView setHighlightCategory:self.revokeCategory];
}

- (void)showPredictView {
    [UIView animateWithDuration:0.5 animations:^{
        self.predictView.alpha=1;
    }                completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.predictView.alpha=0;
            }];
        });
    }];
}

//监控category改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"categoryScrollView.currentCategory"] && object==self) {
        if (!self.inputView.isEdited) {//未编辑才预测
            dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queue, ^{
                double predictValue=[[OBBillManager sharedInstance] predictValueWithCategory:self.categoryScrollView.currentCategory Date:self.date AndLocation:self.location];
                if (predictValue>0) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showPredictView];
                        self.revokeValue=self.inputView.textField.text.doubleValue;
                        self.revokeCategory=self.categoryScrollView.currentCategory;
                        self.inputView.textField.text=[NSString stringWithFormat:@"%.2lf", predictValue];
                        self.inputView.isEdited=YES;
                        self.inputView.isDecimalEdited=NO;
                    });

                }
            });
        }
    }
}

- (void)returnButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
