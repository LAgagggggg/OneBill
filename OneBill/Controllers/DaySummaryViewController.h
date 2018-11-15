//
//  DaySummaryViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "OBInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@class OBDaySummaryTodayCell;

@interface DaySummaryViewController : UIViewController

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) UITableViewCell * selectedCell;
@property (nonatomic,strong) OBDaySummaryTodayCell * todayCell;
@property (nonatomic, strong) OBInteractiveTransition *interactivePop;
@property NSInteger fetchEachTime;

@end

NS_ASSUME_NONNULL_END
