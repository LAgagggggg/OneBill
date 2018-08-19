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
    BillDetailViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVc.view];
    [containView addSubview:toVc.view];
    containView.backgroundColor=[UIColor whiteColor];
    [toVc.summaryCardView.superview layoutIfNeeded];
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
    UIGraphicsBeginImageContextWithOptions(fromVc.addBtn.frame.size, NO, 0);
    [fromVc.addBtn.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *addBtnImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * addBtnImgView=[[UIImageView alloc]initWithImage:addBtnImg];
    addBtnImgView.frame=fromVc.addBtn.frame;
    addBtnImgView.layer.cornerRadius=10.f;
    [containView addSubview:addBtnImgView];
    //准备动画
    fromVc.todayCardView.hidden=YES;
    toVc.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVc.view.alpha=0;
        addBtnImgView.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
            toVc.view.alpha=1;
        }];
    }];
    [UIView replaceView:fromImgView withView:toVc.summaryCardView duration:animationDuration completion:^(BOOL finished) {
        fromVc.view.alpha=1;
        fromVc.todayCardView.hidden=NO;
        [self.transitionContext completeTransition:YES];
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

@end
