//
//  UIView+ReplaceAnimation.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/19.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "UIView+ReplaceAnimation.h"
#import <masonry.h>

@implementation UIView (ReplaceAnimation)

+(void)replaceView:(UIView *)fromView withView:(UIView *)toView duration:(NSTimeInterval)duration backgroundColor:(nullable UIColor *)color transitionContext:(nonnull id<UIViewControllerContextTransitioning>)transitionContext completion:(void (^ _Nullable)(BOOL))completion{
    UIView * fromViewShadowView=[[UIView alloc]initWithFrame:fromView.frame];
    fromViewShadowView.layer.cornerRadius=fromView.layer.cornerRadius;
    fromViewShadowView.layer.shadowColor=fromView.layer.shadowColor;
    fromViewShadowView.layer.shadowOffset=fromView.layer.shadowOffset;
    fromViewShadowView.layer.shadowOpacity=fromView.layer.shadowOpacity;
    fromViewShadowView.layer.shadowRadius=fromView.layer.shadowRadius;
    fromViewShadowView.backgroundColor=color?color:[UIColor whiteColor];
    [fromView.superview insertSubview:fromViewShadowView belowSubview:fromView];
    //准备动画
    fromView.alpha=1;
    toView.alpha=0;
    __block CGRect toFrame=toView.frame;
    fromView.contentMode=UIViewContentModeCenter;
    fromView.layer.masksToBounds=YES;
    //卡片首先移动到顶端
    [UIView animateWithDuration:duration animations:^{
        fromView.frame=toFrame;
        fromViewShadowView.frame=toFrame;
        fromView.alpha=0;
        fromViewShadowView.alpha=0;
        toView.alpha=1;
    } completion:^(BOOL finished) {
        if (transitionContext && ![transitionContext transitionWasCancelled]) {//动画正常进行
            completion(finished);
            if (fromView) [fromView removeFromSuperview];
            if (fromViewShadowView) [fromViewShadowView removeFromSuperview];
        }
        else{//动画取消
            [UIView animateWithDuration:duration animations:^{
            } completion:^(BOOL finished) {
                completion(finished);
                if (fromView) [fromView removeFromSuperview];
                if (fromViewShadowView) [fromViewShadowView removeFromSuperview];
            }];
        }
    }];
}

@end
