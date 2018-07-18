//
//  CategoryView.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryView : UIView

- (instancetype)initWithCategory:(NSString *)text;
- (void)highlight;
- (void)downplay;

@end

NS_ASSUME_NONNULL_END
