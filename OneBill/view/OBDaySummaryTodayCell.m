//
//  OBDaySummaryTodayCellTableViewCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/21.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBDaySummaryTodayCell.h"
#import "OBBillManager.h"
#import <masonry.h>

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define CellEdgeInset 8

@implementation OBDaySummaryTodayCell

- (void)setupTodayCell{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor clearColor];
    UIView * todayView=[[UIView alloc]init];
    todayView.backgroundColor=DarkCyanColor;
    todayView.layer.cornerRadius=10.f;
    todayView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    todayView.layer.shadowOffset = CGSizeMake(0, 6);
    todayView.layer.shadowOpacity = 0.3;
    todayView.layer.shadowRadius = 8;
    [self.contentView addSubview:todayView];
    [todayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top).with.offset(36);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-CellEdgeInset);
    }];
    CGRect frame=self.selectedBackgroundView.frame;
    frame.origin.x+=CellEdgeInset;
    frame.origin.y+=36;
    frame.size.width-=CellEdgeInset;
    frame.size.height-=CellEdgeInset;
    self.selectedBackgroundView.frame=frame;
    self.selectedBackgroundView.layer.cornerRadius=10.f;
    self.selectedBackgroundView.layer.masksToBounds=YES;
    //label
    UILabel * todayLabelL=[[UILabel alloc]init];
    UILabel * todayLabelR=[[UILabel alloc]init];
    [todayLabelL setTextAlignment:NSTextAlignmentRight];
    [todayLabelR setTextAlignment:NSTextAlignmentLeft];
    [todayLabelL setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [todayLabelR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [todayLabelR setText:@" TODAY"];
    [todayLabelL setText:@"your bill"];
    [todayLabelR setTextColor:[UIColor whiteColor] ];
    [todayLabelL setTextColor:[UIColor whiteColor] ];
    [todayView addSubview:todayLabelR];
    [todayView addSubview:todayLabelL];
    [todayLabelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayView.mas_left).with.offset(31);
        make.top.equalTo(todayView.mas_top).with.offset(26);
    }];
    [todayLabelR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayLabelL.mas_right);
        make.top.equalTo(todayView.mas_top).with.offset(26);
    }];
    self.todaySumLabel=[[UILabel alloc]init];
    [self.todaySumLabel setTextColor:[UIColor whiteColor]];
    [self.todaySumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:48]];
    [self.todaySumLabel setTextAlignment:NSTextAlignmentCenter];
    [self.todaySumLabel setText:[NSString stringWithFormat:@"%+.2lf",[[OBBillManager sharedInstance] sumOfDay:[NSDate date]]]];
    [todayView addSubview:self.todaySumLabel];
    [self.todaySumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(todayView.mas_centerX);
        make.top.equalTo(todayLabelR.mas_bottom).with.offset(5);
    }];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += CellEdgeInset;
    frame.size.width -= 2*CellEdgeInset;
    [super setFrame:frame];
}

@end
