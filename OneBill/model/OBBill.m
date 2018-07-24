//
//  OBBill.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBBill.h"

@implementation OBBill
- (instancetype)initWithValue:(double)value Date:(NSDate *)date Location:(CLLocation *)location AndLocationDescription:(NSString *)description Category:(NSString *)category andIsOut:(BOOL)isOut
{
    self = [super init];
    if (self) {
        self.value=value;
        self.date=date;
        self.location=location;
        self.locDescription=description;
        self.category=category;
        self.isOut=isOut;
    }
    return self;
}
@end
