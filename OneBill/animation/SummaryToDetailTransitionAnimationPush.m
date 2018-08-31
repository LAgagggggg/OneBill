//
//  SummaryToDetailTransitionAnimationPush.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/21.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "SummaryToDetailTransitionAnimationPush.h"
#import "DaySummaryViewController.h"
#import "BillDetailViewController.h"
#import "OBDaySummaryCardView.h"
#import "UIView+ReplaceAnimation.h"

@interface SummaryToDetailTransitionAnimationPush()

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation SummaryToDetailTransitionAnimationPush

static float animationDuration=0.6;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    DaySummaryViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BillDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    [fromVC.view layoutIfNeeded];
    [toVC.summaryCardView.superview layoutIfNeeded];
    //点击的cell
    UIGraphicsBeginImageContextWithOptions(fromVC.selectedCell.frame.size, NO, 0);
    [fromVC.selectedCell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fromImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * fromImgView=[[UIImageView alloc]initWithImage:fromImg];
    //计算点击点cell相对屏幕的位置
    CGRect frame=fromVC.selectedCell.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = fromVC.navigationController.navigationBar.frame;
    frame.origin.y=frame.origin.y-fromVC.tableView.contentOffset.y+rectStatus.size.height+rectNav.size.height;
    frame.origin.x=30;
    fromImgView.frame=frame;
    fromImgView.layer.cornerRadius=10.f;
    fromImgView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    fromImgView.layer.shadowOffset=CGSizeMake(0, 6);
    fromImgView.layer.shadowOpacity=0.3;
    fromImgView.layer.shadowRadius=12;
    [containView addSubview:fromImgView];
    //准备动画
    fromVC.selectedCell.hidden=YES;
    toVC.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVC.view.alpha=0;
        if (![self.transitionContext transitionWasCancelled]) toVC.view.alpha=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
        }];
    }];
    [UIView replaceView:fromImgView withView:toVC.summaryCardView duration:animationDuration transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVC.view.alpha=1;
        fromVC.selectedCell.hidden=NO;
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
