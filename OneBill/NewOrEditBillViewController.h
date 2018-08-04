//
//  NewBillViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "model/OBBill.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewOrEditBillViewController : UIViewController
- (void)editModeWithBill:(OBBill *)bill;
@end

NS_ASSUME_NONNULL_END
