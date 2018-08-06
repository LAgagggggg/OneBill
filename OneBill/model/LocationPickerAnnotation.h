//
//  LocationPickerAnnotation.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/6.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationPickerAnnotation : NSObject

@property (nonatomic, assign, readonly)     CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly)       NSString *title;
@property (nonatomic, copy, readonly)       NSString *subtitle;

- (id) initWithCoordinates:(CLLocationCoordinate2D)coordinates Title:(NSString *)title SubTitle:(NSString *)subTitle;
@end

NS_ASSUME_NONNULL_END
