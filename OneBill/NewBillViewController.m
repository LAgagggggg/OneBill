//
//  NewBillViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <masonry.h>
#import "NewBillViewController.h"
#import "view/CategoryView.h"
#import "model/CategoryManager.h"
#import "view/InoutSwitchButton.h"
#import "view/BillValueInputView.h"
#import "view/OBCategoryScrollView.h"
#import "model/OBBillManager.h"
#import <MBProgressHUD.h>

@interface NewBillViewController () <UITextFieldDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic)OBCategoryScrollView * categoryScrollView;
@property (strong,nonatomic)BillValueInputView * inputView;
@property (strong,nonatomic)CategoryManager * categoryManager;
@property (strong,nonatomic)InoutSwitchButton * inoutSwitchBtn;
@property (strong,nonatomic)UIButton * confirmBtn;
@property (strong,nonatomic)UILabel * locationLabel;
@property (strong,nonatomic)UITextField * dateLabel;
@property (strong,nonatomic)CLLocationManager * locationManager;
@property (strong,nonatomic)CLGeocoder * geoCoder;
@property (strong,nonatomic)CLLocation * location;
@property (strong,nonatomic)NSDate * date;
@property (strong,nonatomic)NSMutableString * locDescription;
@end

@implementation NewBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryManager=[CategoryManager sharedInstance];
    [self setUI];
    [self initializeLocationService];
    [self addObserver:self forKeyPath:@"categoryScrollView.currentCategory" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setUI{
    self.locDescription=[[NSMutableString alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.categoryScrollView=[[OBCategoryScrollView alloc]initWithCategorys:self.categoryManager.categoriesArr];
    [self.view addSubview:self.categoryScrollView];
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(97);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(88));
    }];
    self.inputView=[[BillValueInputView alloc]init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(75);
        make.right.equalTo(self.view.mas_right).with.offset(-55);
        make.top.equalTo(self.categoryScrollView.mas_bottom).with.offset(24);
        make.height.equalTo(@(76));
    }];
    self.inputView.delegate=self;
    self.inoutSwitchBtn=[[InoutSwitchButton alloc]init];
    [self.view addSubview:self.inoutSwitchBtn];
    [self.inoutSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.inputView.mas_bottom).with.offset(49);
        make.width.equalTo(@(120));
        make.height.equalTo(@(34));
        
    }];
    UIView * separateLine=[[UIView alloc]init];
    separateLine.backgroundColor=[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:0.3];
    [self.view addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-242.5);
        make.height.equalTo(@(1));
        make.left.equalTo(self.view.mas_left).with.offset(70.5);
        make.right.equalTo(self.view.mas_right).with.offset(-50.5);
    }];
    self.confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.backgroundColor=[UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1];
    self.confirmBtn.layer.cornerRadius=10.f;
    self.confirmBtn.layer.shadowColor=[UIColor grayColor].CGColor;
    self.confirmBtn.layer.shadowOffset=CGSizeMake(0, 5);
    self.confirmBtn.layer.shadowOpacity=0.1;
    self.confirmBtn.layer.shadowRadius=3;
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-81, [UIScreen mainScreen].bounds.size.height-103, 60, 60)];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //确认按钮随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)                                           name:UIKeyboardWillChangeFrameNotification object:nil];
    //地理位置
    UIView * locationView=[[UIView alloc]init];
    locationView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:locationView];
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separateLine.mas_left);
        make.top.equalTo(separateLine.mas_top).with.offset(26.5);
        make.right.equalTo(separateLine.mas_right).with.offset(-40);
        make.height.equalTo(@(34));
    }];
    UIImageView * locationIconView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clearBtn"]];
    [locationView addSubview:locationIconView];
    [locationIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationView.mas_left);
        make.centerY.equalTo(locationView.mas_centerY);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    self.locationLabel=[[UILabel alloc]init];
    [self.locationLabel setTextColor:[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]];
    [self.locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
    [self.locationLabel setNumberOfLines:2];
    self.locationLabel.text=@"Getting Location Information...";
    [locationView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIconView.mas_right).with.offset(25);
        make.centerY.equalTo(locationView.mas_centerY);
        make.right.equalTo(locationView.mas_right);
        make.height.equalTo(@(34));
    }];
    //时间信息
    UIView * dateView=[[UIView alloc]init];
    dateView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separateLine.mas_left);
        make.top.equalTo(locationView.mas_bottom).with.offset(37);
        make.right.equalTo(separateLine.mas_right).with.offset(-40);
        make.height.equalTo(@(20));
    }];
    UIImageView * dateIconView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clearBtn"]];
    [dateView addSubview:dateIconView];
    [dateIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateView.mas_left);
        make.centerY.equalTo(dateView.mas_centerY);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    self.dateLabel=[[UITextField alloc]init];
    [self.dateLabel setTextColor:[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]];
    [self.dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
    [dateView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateIconView.mas_right).with.offset(25);
        make.centerY.equalTo(dateView.mas_centerY);
        make.right.equalTo(dateView.mas_right);
        make.height.equalTo(@(17));
    }];
    //当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm, MMM d";
    self.date=[NSDate date];
    NSString *dateString=[dateFormatter stringFromDate:self.date];
    self.dateLabel.text = dateString;
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.locale =  [NSLocale localeWithLocaleIdentifier:@"us"];
    [datePicker addTarget:self action:@selector(selectedDateChange:) forControlEvents:UIControlEventValueChanged];
    self.dateLabel.inputView = datePicker;
}

- (void)selectedDateChange:(UIDatePicker *)datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm, MMM d";
    NSString *dateString=[dateFormatter stringFromDate:datePicker.date];
    self.date=datePicker.date;
    self.dateLabel.text = dateString;
}

-(void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    //初始化地理编码器
    _geoCoder = [[CLGeocoder alloc] init];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.location = locations.lastObject;
    //预测category
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        NSString * predictCategory=[[OBBillManager sharedInstance] predictCategoryWithDate:self.date Location:self.location];
        dispatch_sync(dispatch_get_main_queue(), ^{
            MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=predictCategory;
            [hud hideAnimated:YES afterDelay:1.0];
        });
    });
    [_geoCoder reverseGeocodeLocation:self.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSMutableString * locStr=[[NSMutableString alloc]init];
            //获取市,省
            [locStr appendString:placemark.locality];
            locStr.length>0? [locStr appendString:@","]:nil;
            [locStr appendString:placemark.administrativeArea];
            [locStr appendString:@"\n"];
            // 位置名
            [self.locDescription appendString:[placemark.addressDictionary objectForKey:@"FormattedAddressLines"][0]];
            [locStr appendString:self.locDescription];
            self.locationLabel.text=locStr;
        }else if (error == nil && [placemarks count] == 0) {
            self.locationLabel.text=@"An error occurred";
        } else if (error != nil){
            self.locationLabel.text=@"An error occurred";
        }
    }];
    [manager stopUpdatingLocation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
    if([self.dateLabel isFirstResponder]){
        [self.dateLabel resignFirstResponder];
    }
    if ([self.categoryScrollView.addTextField isFirstResponder]) {
        [self.categoryScrollView.addTextField resignFirstResponder];
    }
}

//弹出键盘时
-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGRect frame=self.confirmBtn.frame;
    frame.origin.y=keyboardRect.origin.y-frame.size.height-33;
    self.confirmBtn.frame=frame;
}

//******************************ABOUT TEXTFIELD************************************//
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.inputView.isEdited) {
        [self.inputView makeTextCursorToIndex:0];
    }
    else if (!self.inputView.isDecimalEdited){
        NSInteger indexOfPoint=[self.inputView.text rangeOfString:@"."].location;
        [self.inputView makeTextCursorToIndex:indexOfPoint];
    }
    [self.inputView enActived];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.inputView deActived];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [string isEqualToString:@""] && range.length == 1;
    NSInteger indexOfPoint=[self.inputView.text rangeOfString:@"."].location;
    if(range.location>indexOfPoint){
        self.inputView.isEdited=YES;
    }
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        if (range.location>=indexOfPoint) {
            NSInteger offsetAfterPoint=range.location-indexOfPoint;
            if (offsetAfterPoint==0) {
                [self.inputView makeTextCursorToIndex:indexOfPoint];
            }
            else{
                self.inputView.text=[self.inputView.text stringByReplacingCharactersInRange:range withString:@"0"];
                [self.inputView makeTextCursorToIndex:range.location];
            }
            return NO;
        }
    }
    else{
        if(!self.inputView.isEdited){
            self.inputView.text=[string stringByAppendingString:@".00"];
            self.inputView.isEdited=YES;
            [self.inputView makeTextCursorToIndex:indexOfPoint];
            return NO;
        }
        if([string isEqualToString:@"."]){
            [self.inputView makeTextCursorToIndex:indexOfPoint+1];
            return NO;
        }
        else if(range.location>indexOfPoint){
            NSInteger offsetAfterPoint=range.location-indexOfPoint;
            self.inputView.isDecimalEdited=YES;
            if (offsetAfterPoint<=2) {
                self.inputView.text=[self.inputView.text stringByReplacingCharactersInRange:NSMakeRange(range.location, 1) withString:string];
                [self.inputView makeTextCursorToIndex:range.location+1];
            }
            return NO;
        }
    }
    if(self.inputView.text.length>11) return NO;
    return YES;
}
//*********************************************************************************//

-(void)confirmBtnClicked{
    OBBill * bill=[[OBBill alloc]initWithValue:self.inputView.text.doubleValue Date:self.date Location:self.location AndLocationDescription:self.locDescription Category:self.categoryScrollView.selectedView.label.text andIsOut:self.inoutSwitchBtn.isOut];
    [[OBBillManager sharedInstance] insertBill:bill];
    [[OBBillManager sharedInstance] updateSumOfDay:bill.date];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//监控category改变
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"categoryScrollView.currentCategory"]&&object==self) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
        dispatch_async(queue, ^{
            double predictValue=[[OBBillManager sharedInstance] predictValueWithCategory:self.categoryScrollView.currentCategory Date:self.date AndLocation:self.location];
            dispatch_sync(dispatch_get_main_queue(), ^{
                MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode=MBProgressHUDModeText;
                hud.label.text=[NSString stringWithFormat:@"%+.2lf",predictValue];
                [hud hideAnimated:YES afterDelay:1.0];
            });
        });
        
    }
}

@end
