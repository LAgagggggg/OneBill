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
    UIImage * fromImg=fromVC.animationImg;
    CGRect frame=fromVC.todayCardView.frame;
    frame.origin.y-=15;
    frame.size.height+=15;
    UIView * imgWrapperView=[[UIView alloc]initWithFrame:frame];
    imgWrapperView.backgroundColor=MuchLightCyanColor;
    imgWrapperView.layer.cornerRadius=10.f;
    imgWrapperView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    imgWrapperView.layer.shadowOffset=CGSizeMake(0, 6);
    imgWrapperView.layer.shadowOpacity=0.3;
    imgWrapperView.layer.shadowRadius=12;
    UIView * fromImgView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, frame.size.width, frame.size.height-15)];
    fromImgView.layer.contents=(__bridge id)(fromImg.CGImage);
    [imgWrapperView addSubview:fromImgView];
    [containView addSubview:imgWrapperView];
    //button
    UIView * addBtnImgView=[fromVC.addBtn snapshotViewAfterScreenUpdates:NO];
    addBtnImgView.frame=fromVC.addBtn.frame;
    addBtnImgView.layer.cornerRadius=10.f;
    [containView addSubview:addBtnImgView];
    //准备动画
    fromVC.todayCardView.hidden=YES;
    toVC.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVC.view.alpha=0;
        addBtnImgView.alpha=0;
        if (![self.transitionContext transitionWasCancelled]) toVC.view.alpha=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
        }];
    }];
    UIView * todayCardTargetView=[[UIView alloc]initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height-62-136, [UIScreen mainScreen].bounds.size.width-60, 136)];
    [UIView replaceView:imgWrapperView withView:todayCardTargetView duration:animationDuration backgroundColor:nil transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVC.view.alpha=1;
        fromVC.todayCardView.hidden=NO;
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

