//
//  LocationPickerAnnotation.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/6.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "LocationPickerAnnotation.h"

@implementation LocationPickerAnnotation

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)coordinates Title:(NSString *)title SubTitle:(NSString *)subTitle
{
    if (self = [super init]) {
        _coordinate = coordinates;
        _title = title.copy;
        _subtitle = subTitle.copy;
    }
    return self;
}

@end
