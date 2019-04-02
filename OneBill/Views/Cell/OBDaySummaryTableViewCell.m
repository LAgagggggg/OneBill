//
//  OBDaySummaryTableViewCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBDaySummaryTableViewCell.h"

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define CellEdgeInset 8

@interface OBDaySummaryTableViewCell()
@property(nonatomic, strong) UILabel * dateLabel;
@property(nonatomic, strong) UILabel * sumLabel;
@end

@implementation OBDaySummaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //高亮状态
        self.selectedBackgroundView.layer.cornerRadius=10.f;
        self.selectedBackgroundView.layer.masksToBounds=YES;
        //UI
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
//        self.layer.shouldRasterize=YES;
//        self.layer.rasterizationScale=[UIScreen mainScreen].scale;
        //文字
        self.dateLabel=[[UILabel alloc]init];
        [self.dateLabel setTextColor:textGrayColor];
        [self.dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(31);
            make.top.equalTo(self.contentView.mas_top).with.offset(26);
        }];
        self.dateLabel.backgroundColor=self.backgroundColor;
        self.sumLabel=[[UILabel alloc]init];
        [self.sumLabel setTextColor:textGrayColor];
        [self.sumLabel setTextAlignment:NSTextAlignmentCenter];
        [self.sumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:48]];
        [self.contentView addSubview:self.sumLabel];
        [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.sumLabel.backgroundColor=self.backgroundColor;
    }
    return self;
}

- (void)setWithDaySummary:(OBDaySummary *)summary{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM, d";
    self.dateLabel.text=[dateFormatter stringFromDate:summary.date];
    self.sumLabel.text=[NSString stringWithFormat:@"%+.2lf",summary.sum];
}

- (void)layoutSubviews{//shadowPath
    [super layoutSubviews];
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.f];
    [self.layer setShadowPath:shadowPath.CGPath];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 12;
    frame.size.height -= 12;
    frame.origin.x += CellEdgeInset;
    frame.size.width -= 16;
    [super setFrame:frame];
}

@end
