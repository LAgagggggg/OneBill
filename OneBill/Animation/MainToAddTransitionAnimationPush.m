//
// Created by LAgagggggg on 2018/11/15.
// Copyright (c) 2018 ookkee. All rights reserved.
//

#import "MainToAddTransitionAnimationPush.h"
#import "MainViewController.h"
#import "NewOrEditBillViewController.h"

@interface MainToAddTransitionAnimationPush () <CAAnimationDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView * toView;
@property (nonatomic, strong) UIView * whiteView;

@end


@implementation MainToAddTransitionAnimationPush

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext=transitionContext;
    MainViewController * fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NewOrEditBillViewController * toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView * containView=[transitionContext containerView];
    [containView addSubview:fromVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    //白色幕布view
    self.whiteView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [containView addSubview:self.whiteView];
    self.whiteView.backgroundColor=[UIColor whiteColor];
    [containView addSubview:toVC.view];
    self.toView=toVC.view;

    UIView * button=(UIView *)fromVC.addBtn;
    UIBezierPath * startPath=[UIBezierPath bezierPathWithRoundedRect:button.frame cornerRadius:10.f];
    UIBezierPath * endPath=[UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:10.f];
    //赋值给toVc视图layer的mask
    CAShapeLayer * maskLayer=[CAShapeLayer layer];
    maskLayer.path=endPath.CGPath;
    self.whiteView.layer.mask=maskLayer;
    self.toView.alpha=0;

    CABasicAnimation * maskAnimation=[CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue=(__bridge id) startPath.CGPath;
    maskAnimation.toValue=(__bridge id) endPath.CGPath;
    maskAnimation.duration=[self transitionDuration:transitionContext];
    maskAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskAnimation.delegate=self;
    [maskLayer addAnimation:maskAnimation forKey:@"path"];
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return animationDuration;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [UIView animateWithDuration:animationDuration/2 animations:^{
        self.toView.alpha=1;
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:YES];
        [self.whiteView removeFromSuperview];
    }];



}

@end
