//
//  OBMainButton.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OBButtonType) {
    OBButtonTypeAdd,
    OBButtonTypeCheck,
};

@interface OBMainButton : UIView
- (instancetype)initWithType:(OBButtonType)type;
- (void)addTarget:(nullable id)tar action:(nonnull SEL)sel forControlEvents:(UIControlEvents)event;
@end

NS_ASSUME_NONNULL_END
