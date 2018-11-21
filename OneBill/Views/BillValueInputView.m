//
//  BillValueInputView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/20.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "BillValueInputView.h"
#import <masonry.h>

#define LightBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:0.3]
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define lightGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.3]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface BillValueInputView()
@property (nonatomic, strong) UIButton * clearButton;
@property (nonatomic, strong) UILabel * moneyLabel;
@end

@implementation BillValueInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLabel=[[UILabel alloc]init];
        self.moneyLabel.text=@"¥";
        self.moneyLabel.textColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:0.3];
        self.moneyLabel.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:64];
        [self addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(36));
        }];
        self.clearButton=[UIButton buttonWithType:UIButtonTypeSystem];
        self.clearButton.backgroundColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.1];
        self.clearButton.tintColor=textGrayColor;
        self.clearButton.frame=CGRectMake(0, 0, 24, 24);
        self.clearButton.layer.cornerRadius=12;
        [self.clearButton setTitle:@"" forState:UIControlStateNormal];
        [self.clearButton setImage:[UIImage imageNamed:@"clearButton"] forState:UIControlStateNormal];
        [self addSubview:self.clearButton];
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(24));
            make.height.equalTo(@(24));
        }];
        [self.clearButton addTarget:self action:@selector(clearAndEnactived) forControlEvents:UIControlEventTouchUpInside];
        self.textField=[[UITextField alloc]init];
        self.textField.tintColor=DarkBlueColor;
        self.textField.text=@"0.00";
        self.isEdited=NO;
        self.isDecimalEdited=NO;
        self.textField.textColor=lightGrayColor;
        self.textField.textAlignment=NSTextAlignmentCenter;
        self.textField.keyboardType=UIKeyboardTypeDecimalPad;
        self.textField.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:64];
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.moneyLabel.mas_right);
            make.right.equalTo(self.clearButton.mas_left);
        }];
        self.textField.adjustsFontSizeToFitWidth=YES;
        [self makeTextCursorToIndex:0];
    }
    return self;
}

- (void)clearAndEnactived{
    [self enActived];
    self.textField.text=@"0.00";
    self.isEdited=NO;
    self.isDecimalEdited=NO;
    [self.textField becomeFirstResponder];
    [self makeTextCursorToIndex:0];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    _delegate=delegate;
    self.textField.delegate=delegate;
}

- (void)setText:(NSString *)text{
    self.textField.text=text;
}

- (NSString *)text{
    return self.textField.text;
}

-(void)enActived{
    [self.moneyLabel setTextColor:DarkBlueColor];
    [self.textField setTextColor:textGrayColor];
}

-(void)deActived{
    [self.moneyLabel setTextColor:LightBlueColor];
    [self.textField setTextColor:lightGrayColor];
}

- (void)makeTextCursorToIndex:(NSInteger)index{
    UITextPosition * p=[self.textField positionFromPosition:self.textField.beginningOfDocument offset:index];
    self.textField.selectedTextRange=[self.textField textRangeFromPosition:p toPosition:p];
}
@end
