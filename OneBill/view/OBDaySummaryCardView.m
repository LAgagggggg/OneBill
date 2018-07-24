//
//  OBDaySpendCardView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBDaySummaryCardView.h"
#import <masonry.h>

#define DarkCyanColor [UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1]
#define LightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface OBDaySummaryCardView()
@property (strong,nonatomic)UILabel * dateLabel;
@property (strong,nonatomic)UILabel * moneyLabel;
@end

@implementation OBDaySummaryCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-60, 58+25);
        self.backgroundColor=LightCyanColor;
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 10);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
        CAShapeLayer * mainCardLayer=[[CAShapeLayer alloc]init];
        mainCardLayer.backgroundColor=DarkCyanColor.CGColor;
        mainCardLayer.cornerRadius=10.f;
        mainCardLayer.frame=CGRectMake(0, 25, self.frame.size.width, self.frame.size.height-25);
        [self.layer addSublayer:mainCardLayer];
        self.dateLabel=[[UILabel alloc]init];
        [self.dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).with.offset(25);
            make.left.equalTo(self.mas_left).with.offset(31);
        }];
        self.moneyLabel=[[UILabel alloc]init];
        [self.moneyLabel setTextAlignment:NSTextAlignmentRight];
        [self.moneyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:36]];
        [self.moneyLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).with.offset(25);
            make.right.equalTo(self.mas_right).with.offset(-25);
        }];
    }
    return self;
}

- (void)setDate:(NSDate *)date Money:(double)value{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd";
    self.dateLabel.text=[dateFormatter stringFromDate:date];
    self.moneyLabel.text=[NSString stringWithFormat:@"%+.2lf",value];
}

@end
