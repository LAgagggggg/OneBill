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

#define MuchLightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface TodayCardTransitionAnimationPush()

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation TodayCardTransitionAnimationPush

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    MainViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BillDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    [toVC.summaryCardView.superview layoutIfNeeded];
    //原控制器卡片以及覆盖其上的按钮
    UIImage *fromImg = fromVC.animationImg;
    CGRect frame=fromVC.todayCardView.frame;
    UIView * imgWrapperView=[[UIView alloc]initWithFrame:frame];
    imgWrapperView.layer.contents=(__bridge id)(fromImg.CGImage);
    imgWrapperView.layer.contentsScale=[UIScreen mainScreen].scale;
    imgWrapperView.layer.cornerRadius=10.f;
    imgWrapperView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    imgWrapperView.layer.shadowOffset=CGSizeMake(0, 6);
    imgWrapperView.layer.shadowOpacity=0.3;
    imgWrapperView.layer.shadowRadius=6;
//    imgWrapperView.layer.shadowPath=[UIBezierPath bezierPathWithRoundedRect:imgWrapperView.bounds cornerRadius:10.f].CGPath;
    [containView addSubview:imgWrapperView];
    //button
    UIView * addButtonImgView=[fromVC.addButton snapshotViewAfterScreenUpdates:NO];
    addButtonImgView.frame=fromVC.addButton.frame;
    addButtonImgView.layer.cornerRadius=10.f;
    [containView addSubview:addButtonImgView];
    //准备动画
    fromVC.todayCardView.hidden=YES;
    toVC.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVC.view.alpha=0;
        addButtonImgView.alpha=0;
        if (![self.transitionContext transitionWasCancelled]) toVC.view.alpha=1;
    } completion:^(BOOL finished) {

    }];
    [UIView replaceView:imgWrapperView withView:toVC.summaryCardView duration:animationDuration backgroundColor:nil transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVC.view.alpha=1;
        fromVC.todayCardView.hidden=NO;
        addButtonImgView.hidden=YES;
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
