//
//  OBTableViewCardCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/OBBill.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OBTimeLibelWithDate,
    OBTimeLibelTimeOnly,
} OBTimeLabelPreference;

@interface OBTableViewCardCell : UITableViewCell
- (void)setCellWithBill:(OBBill *)bill andStylePreference:(OBTimeLabelPreference)preference;
@end

NS_ASSUME_NONNULL_END
