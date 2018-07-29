//
//  OBBillManager.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBBill.h"
#import "OBDaySummary.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBBillManager : NSObject
+(instancetype)sharedInstance;
//bill
-(BOOL)insertBill:(OBBill *)bill;
-(BOOL)removeBill:(OBBill *)bill;
-(NSArray<OBBill *>*)billsSameDayAsDate:(NSDate *)date;
-(NSArray<OBBill *>*)billsSameMonthAsDate:(NSDate *)date ofCategory:(NSString *)category;
-(BOOL)editBillOfDate:(NSDate *)date Value:(double)value withBill:(OBBill *)newBill;
//sum
-(double)sumOfDay:(NSDate *)date;
-(double)sumOfCategory:(NSString *)category InMonthOfDate:(NSDate *)date;
-(BOOL)updateSumOfDay:(NSDate *)date;
-(NSArray<OBDaySummary *>*)fetchDaySummaryFromIndex:(NSInteger)index WithAmount:(NSInteger)amount;
//predict
-(double)predictValueWithCategory:(NSString *)category Date:(NSDate *)date AndLocation:(nullable CLLocation *)location;
-(nullable NSString *)predictCategoryWithDate:(NSDate *)date Location:(nullable CLLocation *)location;
@end

NS_ASSUME_NONNULL_END
