//
// Created by LAgagggggg on 2018/11/15.
// Copyright (c) 2018 ookkee. All rights reserved.
//

#import "GotoAddTransitionAnimationPush.h"
#import "MainViewController.h"
#import "NewOrEditBillViewController.h"

@interface GotoAddTransitionAnimationPush () <CAAnimationDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView * fromView;
@property (nonatomic, strong) CALayer * whiteLayer;
@property (nonatomic, weak) UIView * clickedSnapView;

@end


@implementation GotoAddTransitionAnimationPush

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext=transitionContext;
    UIViewController * fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NewOrEditBillViewController * toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView * containView=[transitionContext containerView];
    containView.backgroundColor=[UIColor whiteColor];
    //白色幕布view
    [containView addSubview:toVC.view];
    [containView addSubview:fromVC.view];
    self.whiteLayer=[CALayer layer];
    self.whiteLayer.frame=[UIScreen mainScreen].bounds;
    [fromVC.view.layer addSublayer:self.whiteLayer];
    self.whiteLayer.backgroundColor=[UIColor whiteColor].CGColor;
    self.fromView=fromVC.view;
    
    //如果toVC设置了动画起始view则将其放在subview最顶端，否则将fromView截图设置在subview最顶端。
    CGRect startFrame;
    if (toVC.pushAnimationStartView) {
        [self.fromView bringSubviewToFront:toVC.pushAnimationStartView];
        startFrame=toVC.pushAnimationStartView.frame;
    }
    else{
        self.clickedSnapView=[fromVC.view snapshotViewAfterScreenUpdates:NO];
        self.clickedSnapView.frame=fromVC.view.frame;
        CAShapeLayer * imgMaskLayer=[CAShapeLayer layer];
        imgMaskLayer.path=[UIBezierPath bezierPathWithRoundedRect:toVC.pushAnimationStartFrame cornerRadius:10.f].CGPath;
        self.clickedSnapView.layer.mask=imgMaskLayer;
        [self.fromView addSubview:self.clickedSnapView];
        startFrame=toVC.pushAnimationStartFrame;
    }
    UIBezierPath * startPath=[UIBezierPath bezierPathWithRoundedRect:startFrame cornerRadius:10.f];
    UIBezierPath * endPath=[UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:10.f];
    //赋值给toVc视图layer的mask
    CAShapeLayer * maskLayer=[CAShapeLayer layer];
    maskLayer.path=endPath.CGPath;
    self.whiteLayer.mask=maskLayer;

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
        self.fromView.alpha=0;
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:YES];
        [self.whiteLayer removeFromSuperlayer];
        self.fromView.alpha=1;
        [self.clickedSnapView removeFromSuperview];
    }];



}

@end
