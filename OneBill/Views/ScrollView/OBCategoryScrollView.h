//
//  OBCategoryScrollView.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/20.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBCategoryScrollView : UIScrollView

@property (nonatomic, strong)  CategoryView * selectedView;
@property (nonatomic, strong)  NSMutableArray<CategoryView *> * cViewArr;
@property (nonatomic, strong)  NSString * currentCategory;
@property (nonatomic, strong)  UITextField * addTextField;
@property (nonatomic) BOOL alwaysShowSum;
@property (nonatomic, strong)  NSArray<NSString *> * categoryArr;
@property (nonatomic, strong) NSDate * dateOfSum;

- (instancetype)initWithCategorys:(NSArray<NSString *>*)categoriesArr;
- (void)setHighlightCategory:(NSString *)category;
- (void)updateCategories;

@end

NS_ASSUME_NONNULL_END
