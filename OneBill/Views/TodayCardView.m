//
//  TodayCardView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodayCardView.h"

#define DarkCyanColor [UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1]
#define LightCyanColor [UIColor colorWithRed:207/255.0 green:239/255.0 blue:242/255.0 alpha:1]
#define MuchLightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface TodayCardView()

@property (nonatomic, strong) CALayer * secondCardLayer;
@property (nonatomic, strong) CALayer * thirdCardLayer;
@property (nonatomic, strong) UILabel * labelL;
@property (nonatomic, strong) UILabel * labelR;
@end

@implementation TodayCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //三层结构
        double screenHeightAdaptRatio=[UIScreen mainScreen].bounds.size.height/667.0;
        self.backgroundColor=MuchLightCyanColor;
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 6);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 6;
        self.secondCardLayer=[[CALayer alloc]init];
        self.secondCardLayer.backgroundColor=LightCyanColor.CGColor;
        self.secondCardLayer.cornerRadius=10.f;
        [self.layer addSublayer:self.secondCardLayer];
        self.thirdCardLayer=[[CALayer alloc]init];
        self.thirdCardLayer.backgroundColor=DarkCyanColor.CGColor;
        self.thirdCardLayer.cornerRadius=10.f;
        [self.layer addSublayer:self.thirdCardLayer];
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
            make.bottom.equalTo(self.mas_top).with.offset(80*screenHeightAdaptRatio);
            make.right.equalTo(self.mas_centerX);
        }];
        [self.labelR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).with.offset(80*screenHeightAdaptRatio);
            make.left.equalTo(self.mas_centerX);
        }];
        self.labelL.backgroundColor=DarkCyanColor;
        self.labelR.backgroundColor=DarkCyanColor;
        //数字
        self.labelNum=[[UILabel alloc]init];
        self.labelNum.adjustsFontSizeToFitWidth=YES;
        [self.labelNum setTextColor:[UIColor whiteColor]];
        [self.labelNum setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:64]];
        [self.labelNum setTextAlignment:NSTextAlignmentCenter];
        [self.labelNum setText:@"+0.00"];
        [self addSubview:self.labelNum];
        [self.labelNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.labelR.mas_centerY).with.offset(70*screenHeightAdaptRatio);
            make.width.equalTo(self.mas_width).multipliedBy(0.8);
        }];
        self.labelNum.backgroundColor=DarkCyanColor;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    double screenHeightAdaptRatio=[UIScreen mainScreen].bounds.size.height/667.0;
    CGRect frame=self.bounds;
    frame.origin.y+=14*screenHeightAdaptRatio;
    frame.size.height-=14*screenHeightAdaptRatio;
    self.secondCardLayer.frame=frame;
    frame.origin.y+=22*screenHeightAdaptRatio;
    frame.size.height-=22*screenHeightAdaptRatio;
    self.thirdCardLayer.frame=frame;
    //prevent off-screen render
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:10];
    self.layer.shadowPath=shadowPath.CGPath;
    
}

@end
