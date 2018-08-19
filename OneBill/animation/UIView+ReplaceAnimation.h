//
//  UIView+ReplaceAnimation.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/19.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ReplaceAnimation)

+ (void)replaceView:(nonnull UIView *)fromView withView:(nonnull UIView *)toView duration:(NSTimeInterval)duration completion:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
