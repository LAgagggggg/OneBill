//
//  OBMainControllerTransition.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodayCardTransitionAnimationPop.h"
#import "MainViewController.h"
#import "BillDetailViewController.h"
#import "OBDaySummaryCardView.h"
#import "TodayCardView.h"
#import "OBMainButton.h"
#import "UIView+ReplaceAnimation.h"

@interface TodayCardTransitionAnimationPop()

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TodayCardTransitionAnimationPop

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    BillDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    //summary卡片
    [fromVC.summaryCardView.superview layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(fromVC.summaryCardView.frame.size, NO, 0);
    [fromVC.summaryCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fromImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * fromImgView=[[UIImageView alloc]initWithImage:fromImg];
    fromImgView.frame=fromVC.summaryCardView.frame;
    fromImgView.layer.cornerRadius=10.f;
    fromImgView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    fromImgView.layer.shadowOffset=CGSizeMake(0, 6);
    fromImgView.layer.shadowOpacity=0.3;
    fromImgView.layer.shadowRadius=12;
    [containView addSubview:fromImgView];
    //button
    UIView * addBtnImgView=[toVC.addBtn snapshotViewAfterScreenUpdates:NO];
    addBtnImgView.frame=toVC.addBtn.frame;
    addBtnImgView.layer.cornerRadius=10.f;
    [containView addSubview:addBtnImgView];
    //准备动画
    fromVC.summaryCardView.hidden=YES;
    toVC.view.alpha=0;
    addBtnImgView.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVC.view.alpha=0;
        if (![self.transitionContext transitionWasCancelled]) {
            toVC.view.alpha=1;
            addBtnImgView.alpha=1;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
            
        }];
    }];
    [UIView replaceView:fromImgView withView:toVC.todayCardView duration:animationDuration backgroundColor:fromVC.summaryCardView.backgroundColor transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVC.view.alpha=1;
        fromVC.summaryCardView.hidden=NO;
        addBtnImgView.hidden=YES;
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
        }
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return animationDuration;
}

@end
