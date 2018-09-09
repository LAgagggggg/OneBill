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

@property double value;
@property (strong,nonatomic) NSDate * date;
@property (strong,nonatomic) NSString * category;
@property BOOL isOut;
@property (strong,nonatomic) CLLocation * location;
@property (strong,nonatomic) NSString * locDescription;

- (instancetype)initWithValue:(double)value Date:(NSDate *)date Location:(nullable CLLocation *)location AndLocationDescription:(NSString *)description Category:(NSString *)category andIsOut:(BOOL)isOut;

@end

NS_ASSUME_NONNULL_END
