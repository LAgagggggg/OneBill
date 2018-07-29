//
//  OBCategoryChooseView.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/28.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCategoryChooseView : UIView
@property (strong,nonatomic)NSString * selectedCategory;
@property (strong,nonatomic)UIView * dimView;
- (instancetype)initWithCategories:(NSArray<NSString *>*)categoryArr;
@end

NS_ASSUME_NONNULL_END
