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

static float animationDuration=0.8;

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
    //新控制器卡片
    UIGraphicsBeginImageContextWithOptions(toVc.summaryCardView.frame.size, NO, 0);
    [toVc.summaryCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *toImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * toImgView=[[UIImageView alloc]initWithImage:toImg];
    toImgView.frame=toVc.summaryCardView.frame;
    toImgView.layer.cornerRadius=10.f;
//    [containView addSubview:toImgView];

    toVc.view.alpha=0;

    [UIView transitionFromView:fromImgView toView:toImgView duration:animationDuration options:UIViewAnimationOptionAllowAnimatedContent completion:nil];
    [UIView animateWithDuration:animationDuration animations:^{
        fromVc.view.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
            toVc.view.alpha=1;
        } completion:^(BOOL finished) {
            fromVc.view.alpha=1;
            [fromImgView removeFromSuperview];
            [toImgView removeFromSuperview];
            [self.transitionContext completeTransition:YES];
            [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
        }];
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
