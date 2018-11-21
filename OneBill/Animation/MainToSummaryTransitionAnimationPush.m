//
//  MainToSummaryTransitionAnimationPush.m
//  OneBill
//
//  Created by LAgagggggg on 2018/9/1.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "MainToSummaryTransitionAnimationPush.h"
#import "MainViewController.h"
#import "DaySummaryViewController.h"
#import "OBDaySummaryTodayCell.h"
#import "TodayCardView.h"
#import "OBMainButton.h"
#import "UIView+ReplaceAnimation.h"

#define MuchLightCyanColor [UIColor colorWithRed:241/255.0 green:251/255.0 blue:251/255.0 alpha:1]

@interface MainToSummaryTransitionAnimationPush()

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation MainToSummaryTransitionAnimationPush

static float animationDuration=0.6;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    MainViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DaySummaryViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
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
        [UIView animateWithDuration:animationDuration animations:^{
        }];
    }];
    UIView * todayCardTargetView=[[UIView alloc]initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height-62-136, [UIScreen mainScreen].bounds.size.width-60, 136)];
    [UIView replaceView:imgWrapperView withView:todayCardTargetView duration:animationDuration backgroundColor:nil transitionContext:self.transitionContext completion:^(BOOL finished) {
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

