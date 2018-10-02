//
//  TodayCardView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodayCardView.h"
#import <Masonry.h>

#define DarkCyanColor [UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1]
#define LightCyanColor [UIColor colorWithRed:207/255.0 green:239/255.0 blue:242/255.0 alpha:1]
#define MuchLightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface TodayCardView()
@property (strong,nonatomic)UILabel * labelL;
@property (strong,nonatomic)UILabel * labelR;
@end

@implementation TodayCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //三层结构
        self.backgroundColor=LightCyanColor;
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=MuchLightCyanColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -15);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 0;
        UIView * mainCardView=[[UIView alloc]init];
        mainCardView.backgroundColor=DarkCyanColor;
        mainCardView.layer.cornerRadius=10.f;
        mainCardView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
        mainCardView.layer.shadowOffset=CGSizeMake(0, 6);
        mainCardView.layer.shadowOpacity=0.3;
        mainCardView.layer.shadowRadius=12;
        [self addSubview:mainCardView];
        [mainCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).with.offset(20);
            make.bottom.equalTo(self.mas_bottom);
        }];
        //文字
        self.labelL=[[UILabel alloc]init];
        self.labelR=[[UILabel alloc]init];
        [self.labelL setTextAlignment:NSTextAlignmentRight];
        [self.labelR setTextAlignment:NSTextAlignmentLeft];
        [self.labelL setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.labelR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [self.labelR setText:@" TODAY"];
        [self.labelL setText:@"your bill"];
        [self.labelR setTextColor:[UIColor whiteColor] ];
        [self.labelL setTextColor:[UIColor whiteColor] ];
        [self addSubview:self.labelR];
        [self addSubview:self.labelL];
        [self.labelL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(80);
            make.right.equalTo(self.mas_centerX);
        }];
        [self.labelR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(80);
            make.left.equalTo(self.mas_centerX);
        }];
        //数字
        self.labelNum=[[UILabel alloc]init];
        [self.labelNum setTextColor:[UIColor whiteColor]];
        [self.labelNum setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:64]];
        [self.labelNum setTextAlignment:NSTextAlignmentCenter];
        [self.labelNum setText:@"+0.00"];
        [self addSubview:self.labelNum];
        [self.labelNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.labelR.mas_centerY).with.offset(70);
        }];
    }
    return self;
}

@end
