//
//  OBMainControllerTransition.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodayCardTransitionAnimationPush.h"
#import "MainViewController.h"
#import "BillDetailViewController.h"
#import "view/OBDaySummaryCardView.h"
#import "view/TodayCardView.h"

@interface TodayCardTransitionAnimationPush()<CAAnimationDelegate>

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TodayCardTransitionAnimationPush

static float animationDuration=0.4;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    MainViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BillDetailViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVc.view];
    [containView addSubview:toVc.view];
    containView.backgroundColor=[UIColor whiteColor];
    [toVc.summaryCardView.superview layoutIfNeeded];
    //原控制器卡片
    UIGraphicsBeginImageContextWithOptions(fromVc.todayCardView.frame.size, NO, 0);
    [fromVc.todayCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fromImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * fromImgView=[[UIImageView alloc]initWithImage:fromImg];
    fromImgView.frame=fromVc.todayCardView.frame;
    fromImgView.layer.cornerRadius=10.f;
    [containView addSubview:fromImgView];
    toVc.view.alpha=0;
    __block CGRect frame=fromImgView.frame;
    frame.origin.y=toVc.summaryCardView.frame.origin.y+3;
    fromImgView.contentMode=UIViewContentModeCenter;
    fromImgView.layer.masksToBounds=YES;
    //卡片首先移动到顶端
    [UIView animateWithDuration:animationDuration animations:^{
        fromVc.view.alpha=0;
        fromImgView.frame=frame;
    } completion:^(BOOL finished) {
        frame.size.height=toVc.summaryCardView.frame.size.height;
        [UIView animateWithDuration:animationDuration animations:^{
            //卡片缩小 新界面显现
            fromImgView.frame=frame;
            toVc.view.alpha=1;
        } completion:^(BOOL finished) {
            //完成后清扫
            fromVc.view.alpha=1;
            [self.transitionContext completeTransition:YES];
            [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration*3/5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:animationDuration animations:^{
                fromImgView.alpha=0;
            }];
        });
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

//#pragma mark - CAAnimationDelegate
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//
//    //告诉 iOS 这个 transition 完成
//    [self.transitionContext completeTransition:YES];
//    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
//    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
//
//}

@end
