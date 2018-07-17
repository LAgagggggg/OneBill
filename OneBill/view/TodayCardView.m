//
//  TodayCardView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodayCardView.h"
#import <Masonry.h>

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define LightCyanColor [UIColor colorWithRed:207/255.0 green:239/255.0 blue:242/255.0 alpha:1]
#define MuchLightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface TodayCardView()
@property (strong,nonatomic)UILabel * labelL;
@property (strong,nonatomic)UILabel * labelR;
@property (strong,nonatomic)UILabel * labelNum;
@end

@implementation TodayCardView

- (void)awakeFromNib{
    [super awakeFromNib];
    //三层结构
    self.backgroundColor=LightCyanColor;
    self.layer.cornerRadius=10.f;
    self.layer.shadowColor=MuchLightCyanColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -15);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 0;
    CAShapeLayer * mainCardLayer=[[CAShapeLayer alloc]init];
    mainCardLayer.backgroundColor=DarkCyanColor.CGColor;
    mainCardLayer.cornerRadius=10.f;
    mainCardLayer.frame=CGRectMake(0, 20, self.frame.size.width, self.frame.size.height-20);
    mainCardLayer.shadowColor=[UIColor grayColor].CGColor;
    mainCardLayer.shadowOffset=CGSizeMake(0, 5);
    mainCardLayer.shadowOpacity=0.3;
    mainCardLayer.shadowRadius=3;
    [self.layer addSublayer:mainCardLayer];
    //文字
    self.labelL=[[UILabel alloc]init];
    self.labelR=[[UILabel alloc]init];
    [self.labelL setTextAlignment:NSTextAlignmentRight];
    [self.labelR setTextAlignment:NSTextAlignmentLeft];
    [self.labelL setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] ];
    [self.labelR setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightBold] ];
    [self.labelR setText:@" Today"];
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
    [self.labelNum setFont:[UIFont systemFontOfSize:66 weight:UIFontWeightLight]];
    [self.labelNum setTextAlignment:NSTextAlignmentCenter];
    [self.labelNum setText:@"+999.99"];
    [self addSubview:self.labelNum];
    [self.labelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.labelR.mas_centerY).with.offset(70);
    }];
}

@end
