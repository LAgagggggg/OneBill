//
//  OBInteractiveTransition.m
//  OBTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "OBInteractiveTransition.h"

@interface OBInteractiveTransition ()

@property (nonatomic, assign) OBInteractiveTransitionGestureDirection direction;
@property (nonatomic, assign) OBInteractiveTransitionType type;
@property (nonatomic, strong)  UIImpactFeedbackGenerator * impactFeedBack;

@end

@implementation OBInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(OBInteractiveTransitionType)type GestureDirection:(OBInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(OBInteractiveTransitionType)type GestureDirection:(OBInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
        _impactFeedBackEnable=YES;
        _impactFeedBack=[[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)pan{
    [pan addTarget:self action:@selector(handleGesture:)];
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat percent = 0;
    switch (_direction) {
        case OBInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case OBInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case OBInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case OBInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            percent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态并开始相应的事件
            if(self.impactFeedBackEnable) [self.impactFeedBack prepare];
            break;
        case UIGestureRecognizerStateChanged:{
//            NSLog(@"%lf in direction%lu",percent,(unsigned long)self.direction);
            //手势过程中
            if (percent>0 && !self.interation) {
                self.interation = YES;
                [self startGesture];
                if(self.impactFeedBackEnable) [self.impactFeedBack impactOccurred];
                break;
            }
            if (percent<=0) {
                self.interation=NO;
                [self cancelInteractiveTransition];
                break;
            }
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半
            self.interation = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
                if(self.impactFeedBackEnable) [self.impactFeedBack impactOccurred];
            }else{
                [self cancelInteractiveTransition];
                if(self.impactFeedBackEnable) [self.impactFeedBack impactOccurred];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    switch (_type) {
        case OBInteractiveTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case OBInteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case OBInteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case OBInteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}
@end
