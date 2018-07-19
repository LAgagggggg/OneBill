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
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface BillValueInputView()
@property (strong,nonatomic)UIButton * clearBtn;
@property (strong,nonatomic)UITextField * textField;
@end

@implementation BillValueInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel * moneyLabel=[[UILabel alloc]init];
        moneyLabel.text=@"¥";
        moneyLabel.textColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:0.3];
        moneyLabel.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:64];
        [self addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@(36));
        }];
        self.clearBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        self.clearBtn.backgroundColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.1];
        self.clearBtn.tintColor=textGrayColor;
        self.clearBtn.frame=CGRectMake(0, 0, 24, 24);
        self.clearBtn.layer.cornerRadius=12;
        [self.clearBtn setTitle:@"X" forState:UIControlStateNormal];
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(24));
            make.height.equalTo(@(24));
        }];
        self.textField=[[UITextField alloc]init];
        self.textField.tintColor=DarkBlueColor;
        self.textField.placeholder=@"0.00";
        self.textField.textAlignment=NSTextAlignmentCenter;
        self.textField.keyboardType=UIKeyboardTypeDecimalPad;
        self.textField.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:64];
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(moneyLabel.mas_right);
            make.right.equalTo(self.clearBtn.mas_left);
        }];
    }
    return self;
}

@end
