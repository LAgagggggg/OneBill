//
//  NewBillViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "NewBillViewController.h"
#import "view/CategoryView.h"
#import "model/CategoryManager.h"
#import "view/InoutSwitchButton.h"
#import "view/BillValueInputView.h"
#import "view/OBCategoryScrollView.h"
#import <masonry.h>

@interface NewBillViewController () <UITextFieldDelegate>
@property (strong,nonatomic)UIScrollView * categoryScrollView;
@property (strong,nonatomic)BillValueInputView * inputView;
@property (strong,nonatomic)CategoryManager * categoryManager;
@property (strong,nonatomic)UIButton * confirmBtn;
@end

@implementation NewBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryManager=[CategoryManager sharedInstance];
    [self setUI];
}

- (void)setUI{
    self.view.backgroundColor=[UIColor whiteColor];
    self.categoryScrollView=[[OBCategoryScrollView alloc]initWithCategorys:self.categoryManager.categoriesArr];
    [self.view addSubview:self.categoryScrollView];
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(123);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(62));
    }];
    self.inputView=[[BillValueInputView alloc]init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(75);
        make.right.equalTo(self.view.mas_right).with.offset(-55);
        make.top.equalTo(self.categoryScrollView.mas_top).with.offset(86);
        make.height.equalTo(@(76));
    }];
    self.inputView.delegate=self;
    InoutSwitchButton * inoutSwitchBtn=[[InoutSwitchButton alloc]init];
    [self.view addSubview:inoutSwitchBtn];
    [inoutSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-21);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-43);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    //确认按钮随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)                                           name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
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
    NSLog(@"%lu",(unsigned long)[self.inputView.text rangeOfString:@"."].location);
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
    NSLog(@"%@",NSStringFromRange(range));
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [string isEqualToString:@""] && range.length == 1;
    NSInteger indexOfPoint=[self.inputView.text rangeOfString:@"."].location;
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

@end
