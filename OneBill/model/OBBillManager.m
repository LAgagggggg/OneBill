//
//  OBBillManager.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBBillManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation OBBillManager

+(instancetype)sharedInstance{
    //单例创建数据库
    static OBBillManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[OBBillManager alloc]init];
        NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
        NSString *fileName = [doc stringByAppendingPathComponent:@"OBBillDatabase.sqlite"];
        manager.database = [FMDatabase databaseWithPath:fileName];
        if ([manager.database open])
        {
            NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (value float, date datetime, location blob,category text,isOut integer);",@"BillsTable"];
            BOOL result = [manager.database executeUpdate:sql];
            if (result) NSLog(@"创建%@成功",@"BillsTable");
        }
    });
    return manager;
}

- (BOOL)insertBill:(OBBill *)bill{
    BOOL result;
    NSData * locData=[NSKeyedArchiver archivedDataWithRootObject:bill.location];
    NSString * sql=[NSString stringWithFormat:@"insert into %@(value,date,location,category,isOut) VALUES(?,?,?,?,?);",@"BillsTable"];
    result=[self.database executeUpdate:sql,bill.value,bill.date,locData,bill.category,@(bill.isOut)];
    return result;
}

@end
