//
//  PopUpDateSelectView.h
//  OneBill
//
//  Created by LAgagggggg on 2019/1/19.
//  Copyright © 2019 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopUpDateSelectView : UIView

@property (nonatomic, weak) id delegate;

- (instancetype)initWithView:(UIView *)view;
- (void)popUp;

@end

@protocol PopUpDateSelectViewDelegate <NSObject>

- (void)dateSelectView:(PopUpDateSelectView *)dateSelectView didSelectDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
