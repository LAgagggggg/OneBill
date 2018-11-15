//
//  OBTableViewCardCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBBill.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OBTimeLibelWithDate,
    OBTimeLibelTimeOnly,
} OBTimeLabelPreference;

@interface OBDetailCardCell : UITableViewCell
@property (nonatomic, strong) UIButton * categoryBtn;
//adapt for under iOS11
@property BOOL frameSetFlag;
@property BOOL frameSolidFlag;
@property CGRect solidFrame;

- (void)setCellWithBill:(OBBill *)bill andStylePreference:(OBTimeLabelPreference)preference;

@end

NS_ASSUME_NONNULL_END
