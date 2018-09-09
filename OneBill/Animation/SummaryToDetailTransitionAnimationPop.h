//
//  SummaryToDetailTransitionAnimationPop.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OBInteractiveTransition;

@interface SummaryToDetailTransitionAnimationPop : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) OBInteractiveTransition *interactivePop;

@end

NS_ASSUME_NONNULL_END
