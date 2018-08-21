//
//  DaySummaryViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DaySummaryViewController : UIViewController

@property (strong,nonatomic)UITableView * tableView;
@property (nonatomic,strong) UITableViewCell * selectedCell;

@end

NS_ASSUME_NONNULL_END
