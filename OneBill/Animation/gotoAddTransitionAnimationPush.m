//
// Created by LAgagggggg on 2018/11/15.
// Copyright (c) 2018 ookkee. All rights reserved.
//

#import "gotoAddTransitionAnimationPush.h"
#import "MainViewController.h"
#import "NewOrEditBillViewController.h"

@interface gotoAddTransitionAnimationPush () <CAAnimationDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView * toView;
@property (nonatomic, strong) CALayer * whiteLayer;

@end


@implementation gotoAddTransitionAnimationPush

static float animationDuration=0.5;

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext=transitionContext;
    UIViewController * fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NewOrEditBillViewController * toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView * containView=[transitionContext containerView];
    [containView addSubview:fromVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    //白色幕布view
    self.whiteLayer=[CALayer layer];
    self.whiteLayer.frame=[UIScreen mainScreen].bounds;
    [containView.layer addSublayer:self.whiteLayer];
    self.whiteLayer.backgroundColor=[UIColor whiteColor].CGColor;
    [containView addSubview:toVC.view];
    self.toView=toVC.view;

    CGRect startFrame;
    if ([fromVC isMemberOfClass:[MainViewController class]]) {
        MainViewController * mainVC=(MainViewController *)fromVC;
        startFrame=((UIView *)mainVC.addBtn).frame;
    }
    else{
        startFrame=CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 1, 1);
    }
    UIBezierPath * startPath=[UIBezierPath bezierPathWithRoundedRect:startFrame cornerRadius:10.f];
    UIBezierPath * endPath=[UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:10.f];
    //赋值给toVc视图layer的mask
    CAShapeLayer * maskLayer=[CAShapeLayer layer];
    maskLayer.path=endPath.CGPath;
    self.whiteLayer.mask=maskLayer;
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
        [self.whiteLayer removeFromSuperlayer];
    }];



}

@end
