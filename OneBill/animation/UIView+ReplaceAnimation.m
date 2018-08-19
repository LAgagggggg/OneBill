//
//  UIView+ReplaceAnimation.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/19.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "UIView+ReplaceAnimation.h"

@implementation UIView (ReplaceAnimation)

+(void)replaceView:(UIView *)fromView withView:(UIView *)toView duration:(NSTimeInterval)duration transitionContext:(nonnull id<UIViewControllerContextTransitioning>)transitionContext completion:(void (^ _Nullable)(BOOL))completion{
    //准备动画
    fromView.alpha=1;
    toView.alpha=0;
    __block CGRect frame=fromView.frame;
    frame.origin.x=toView.frame.origin.x;
    frame.origin.y=toView.frame.origin.y;
    fromView.contentMode=UIViewContentModeCenter;
    fromView.layer.masksToBounds=YES;
    //接近位置后开始消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration*3/5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration animations:^{
            toView.alpha=1;
        }];
    });
    //卡片首先移动到顶端
    [UIView animateWithDuration:duration animations:^{
        fromView.frame=frame;
    } completion:^(BOOL finished) {
        if (transitionContext && ![transitionContext transitionWasCancelled]) {//动画正常进行
            frame.size.width=toView.frame.size.width;
            frame.size.height=toView.frame.size.height;
            [UIView animateWithDuration:duration animations:^{
                //卡片缩小 新界面显现
                fromView.frame=frame;
                fromView.alpha=0;
            } completion:^(BOOL finished) {
                //完成后
                completion(finished);
                if (fromView) [fromView removeFromSuperview];
            }];
        }
        else{//动画取消
            [UIView animateWithDuration:duration animations:^{
                fromView.alpha=0;
            } completion:^(BOOL finished) {
                completion(finished);
                if (fromView) [fromView removeFromSuperview];
            }];
        }
    }];
}

@end
