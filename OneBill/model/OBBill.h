//
//  OBBill.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

NS_ASSUME_NONNULL_BEGIN

@interface OBBill : NSObject
@property float value;
@property (strong,nonatomic) NSDate * date;
@property (strong,nonatomic) NSString * category;
@property BOOL isOut;
@property (strong,nonatomic) CLLocation * location;
- (instancetype)initWithValue:(float)value Date:(NSDate *)date Location:(CLLocation *)location Category:(NSString *)category andIsOut:(BOOL)isOut;
@end

NS_ASSUME_NONNULL_END
