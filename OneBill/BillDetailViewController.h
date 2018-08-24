//
//  BillDetailViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBBillManager.h"
#import "animation/OBInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

@class OBDaySummaryCardView;

@interface BillDetailViewController : UIViewController

@property (strong,nonatomic)OBDaySummaryCardView * summaryCardView;
@property (strong,nonatomic)NSDate * date;
@property (nonatomic, strong) OBInteractiveTransition *interactivePop;

- (instancetype)initWithBills:(NSArray<OBBill *>*)bills;

@end

NS_ASSUME_NONNULL_END
