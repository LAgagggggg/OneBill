//
//  OBBillManager.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "OBBill.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBBillManager : NSObject
@property(strong,nonatomic)FMDatabase * database;
+(instancetype)sharedInstance;
-(BOOL)insertBill:(OBBill *)bill;
@end

NS_ASSUME_NONNULL_END
