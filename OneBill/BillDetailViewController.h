//
//  BillDetailViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/OBBillManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillDetailViewController : UIViewController
@property (strong,nonatomic)NSDate * date;
- (instancetype)initWithBills:(NSArray<OBBill *>*)bills;
@end

NS_ASSUME_NONNULL_END
