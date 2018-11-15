//
//  OBCategoryChooseViewCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/28.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCategoryChooseViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * label;
- (void)highlight;
- (void)downplay;
@end

NS_ASSUME_NONNULL_END
