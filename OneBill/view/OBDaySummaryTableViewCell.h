//
//  OBDaySummaryTableViewCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/OBDaySummary.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBDaySummaryTableViewCell : UITableViewCell
-(void)setWithDaySummary:(OBDaySummary *)summary;
@end

NS_ASSUME_NONNULL_END
