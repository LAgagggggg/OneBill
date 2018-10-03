//
//  CategoryManagerCell.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryManagerCell : UITableViewCell
@property(strong,nonatomic)UIButton * editBtn;
@property(strong,nonatomic)UITextField * categoryTextField;
@property BOOL isSelected;
@property BOOL hasHideReorderControl;
- (void)setWithCategory:(NSString *)category;
- (void)beginMultiDelete;
- (void)endMultiDelete;
- (void)multiDeleteBeSelected;
- (void)multiDeleteBeDeselected;
@end

NS_ASSUME_NONNULL_END
