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
@property (strong,nonatomic) CategoryView * selectedView;
@property (strong,nonatomic) NSMutableArray<CategoryView *> * cViewArr;
@property (strong,nonatomic) NSString * currentCategory;
@property (strong,nonatomic) UIView * sumLabelView;
@property (strong,nonatomic) UITextField * addTextField;
- (instancetype)initWithCategorys:(NSArray<NSString *>*)categoriesArr;
@end

NS_ASSUME_NONNULL_END
