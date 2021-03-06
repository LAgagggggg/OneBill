//
//  OBMapPickerViewController.h
//  OneBill
//
//  Created by LAgagggggg on 2018/8/5.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBMapPickerViewController : UIViewController

@property (nonatomic, strong)  void(^locationPickDoneHandler)(CLLocation *location);
@property (nonatomic, strong) CLLocation *location;

@end

NS_ASSUME_NONNULL_END
