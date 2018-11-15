//
//  OBDaySummaryTodayCellTableViewCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/21.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBDaySummaryTodayCell : UITableViewCell

@property (nonatomic, strong) UILabel * todaySumLabel;
@property (nonatomic, strong) UIView * todayView;

- (void)setupTodayCell;

@end

NS_ASSUME_NONNULL_END
