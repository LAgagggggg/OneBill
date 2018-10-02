//
//  OBInteractiveTransition.h
//  OBTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)(void);

typedef NS_ENUM(NSUInteger, OBInteractiveTransitionGestureDirection) {//手势的方向
    OBInteractiveTransitionGestureDirectionLeft = 0,
    OBInteractiveTransitionGestureDirectionRight,
    OBInteractiveTransitionGestureDirectionUp,
    OBInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, OBInteractiveTransitionType) {//手势控制哪种转场
    OBInteractiveTransitionTypePresent = 0,
    OBInteractiveTransitionTypeDismiss,
    OBInteractiveTransitionTypePush,
    OBInteractiveTransitionTypePop,
};

@interface OBInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interation;
@property (nonatomic, copy) GestureConifg presentConifg;
@property (nonatomic, copy) GestureConifg pushConifg;
@property (nonatomic, weak) UIViewController *vc;
@property BOOL impactFeedBackEnable;//default is YES

+ (instancetype)interactiveTransitionWithTransitionType:(OBInteractiveTransitionType)type GestureDirection:(OBInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(OBInteractiveTransitionType)type GestureDirection:(OBInteractiveTransitionGestureDirection)direction;
//给传入的控制器添加手势
- (void)addPanGestureForViewController:(UIViewController *)viewController;
- (void)setPanGestureRecognizer:(UIPanGestureRecognizer *)pan;

@end
