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
#import "OBDaySummaryCardView.h"
#import "TodayCardView.h"
#import "OBMainButton.h"
#import "UIView+ReplaceAnimation.h"

@interface TodayCardTransitionAnimationPush()<CAAnimationDelegate>

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TodayCardTransitionAnimationPush

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    MainViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BillDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVc.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    [toVC.summaryCardView.superview layoutIfNeeded];
    //原控制器卡片以及覆盖其上的按钮
    UIGraphicsBeginImageContextWithOptions(fromVc.todayCardView.frame.size, NO, 0);
    [fromVc.todayCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fromImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * fromImgView=[[UIImageView alloc]initWithImage:fromImg];
    fromImgView.frame=fromVc.todayCardView.frame;
    fromImgView.layer.cornerRadius=10.f;
    [containView addSubview:fromImgView];
    //button
    UIView * addBtnImgView=[fromVc.addBtn snapshotViewAfterScreenUpdates:NO];
    addBtnImgView.frame=fromVc.addBtn.frame;
    addBtnImgView.layer.cornerRadius=10.f;
    [containView addSubview:addBtnImgView];
    //准备动画
    fromVc.todayCardView.hidden=YES;
    toVC.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVc.view.alpha=0;
        addBtnImgView.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
            if (![self.transitionContext transitionWasCancelled]) toVC.view.alpha=1;
        }];
    }];
    [UIView replaceView:fromImgView withView:toVC.summaryCardView duration:animationDuration transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVc.view.alpha=1;
        fromVc.todayCardView.hidden=NO;
        addBtnImgView.hidden=YES;
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
        }
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

@end
