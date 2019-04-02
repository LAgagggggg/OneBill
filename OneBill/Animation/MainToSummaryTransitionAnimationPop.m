//
//  MainToSummaryTransitionAnimationPop.m
//  OneBill
//
//  Created by LAgagggggg on 2018/9/1.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "MainToSummaryTransitionAnimationPop.h"
#import "MainViewController.h"
#import "DaySummaryViewController.h"
#import "OBDaySummaryTodayCell.h"
#import "TodayCardView.h"
#import "UIView+ReplaceAnimation.h"

@interface MainToSummaryTransitionAnimationPop()

@property (nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation MainToSummaryTransitionAnimationPop

static float animationDuration=0.6;

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    DaySummaryViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView *containView = [transitionContext containerView];
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    //原控制器卡片以及覆盖其上的按钮
    UIGraphicsBeginImageContextWithOptions(fromVC.todayCell.todayView.frame.size, NO, 0);
    [fromVC.todayCell.todayView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *fromImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * fromImgView=[[UIImageView alloc]initWithImage:fromImg];
    //计算cell相对屏幕的frame
//    [fromVC.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[fromVC.tableView numberOfRowsInSection:0]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    CGRect cellFrame=CGRectMake(fromVC.tableView.frame.origin.x+fromVC.todayCell.frame.origin.x, fromVC.todayCell.frame.origin.y-fromVC.tableView.contentOffset.y+fromVC.tableView.frame.origin.y+fromVC.todayCell.todayView.frame.origin.y, fromVC.todayCell.todayView.frame.size.width, fromVC.todayCell.todayView.frame.size.height);
    if (fromVC.tableView.contentSize.height-[UIScreen mainScreen].bounds.size.height-100>fromVC.tableView.contentOffset.y ) {//刷新之后todayCell的frame没有更新fix
        cellFrame.origin.y=[UIScreen mainScreen].bounds.size.height+100;
    }
    fromImgView.frame=cellFrame;
    fromImgView.layer.cornerRadius=10.f;
    fromImgView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    fromImgView.layer.shadowOffset=CGSizeMake(0, 6);
    fromImgView.layer.shadowOpacity=0.3;
    fromImgView.layer.shadowRadius=12;
    [containView addSubview:fromImgView];
    //准备动画
    fromVC.todayCell.hidden=YES;
    toVC.view.alpha=0;
    [UIView animateWithDuration:animationDuration animations:^{
        fromVC.view.alpha=0;
        if (![self.transitionContext transitionWasCancelled]) toVC.view.alpha=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration animations:^{
        }];
    }];
    [UIView replaceView:fromImgView withView:toVC.todayCardView duration:animationDuration backgroundColor:fromVC.todayCell.todayView.backgroundColor transitionContext:self.transitionContext completion:^(BOOL finished) {
        fromVC.view.alpha=1;
        fromVC.todayCell.hidden=NO;
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


