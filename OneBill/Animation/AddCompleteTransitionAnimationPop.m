//
//  AddCompleteTransitionAnimationPop.m
//  OneBill
//
//  Created by LAgagggggg on 2019/3/1.
//  Copyright © 2019 ookkee. All rights reserved.
//

#import "AddCompleteTransitionAnimationPop.h"
#import "NewOrEditBillViewController.h"

@interface AddCompleteTransitionAnimationPop () <CAAnimationDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView * fromView;
@property (nonatomic, strong) CALayer * curtainLayer;

@end

@implementation AddCompleteTransitionAnimationPop

static float animationDuration=0.6;

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext=transitionContext;
    NewOrEditBillViewController * fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //获得容器视图
    UIView * containView=[transitionContext containerView];
    [containView addSubview:toVC.view];
    containView.backgroundColor=[UIColor whiteColor];
    [containView addSubview:fromVC.view];
    //白色幕布view
    self.curtainLayer=[CALayer layer];
    self.curtainLayer.frame=[UIScreen mainScreen].bounds;
    [fromVC.view.layer addSublayer:self.curtainLayer];
    self.curtainLayer.backgroundColor=[UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1].CGColor;
    self.fromView=fromVC.view;
    //被点击的按钮
//    UIView * confirmButtonImgView=[fromVC.confirmButton snapshotViewAfterScreenUpdates:NO];
//    confirmButtonImgView.frame=fromVC.confirmButton.frame;
//    confirmButtonImgView.layer.cornerRadius=10.f;
//    [self.fromView addSubview:confirmButtonImgView];
    [self.fromView bringSubviewToFront:fromVC.confirmButton];
    
    CGRect startFrame=fromVC.confirmButton.frame;
    UIBezierPath * startPath=[UIBezierPath bezierPathWithRoundedRect:startFrame cornerRadius:10.f];
    UIBezierPath * endPath=[UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:10.f];
    //赋值给toVc视图layer的mask
    CAShapeLayer * maskLayer=[CAShapeLayer layer];
    maskLayer.path=endPath.CGPath;
    self.curtainLayer.mask=maskLayer;
    
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
        [self.curtainLayer removeFromSuperlayer];
    }];
}


@end
