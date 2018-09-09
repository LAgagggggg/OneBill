//
//  BillValueInputView.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/20.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillValueInputView : UIView
@property (strong,nonatomic)UITextField * textField;
@property (strong,nonatomic)NSString * text;
@property(nullable, nonatomic,weak)   id<UITextFieldDelegate> delegate;
@property BOOL isEdited;
@property BOOL isDecimalEdited;

- (void)enActived;
- (void)deActived;
- (void)makeTextCursorToIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
