//
//  OBBillManager.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBBillManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OBBillManager()
@property (strong,nonatomic)NSString * dbPath;
@property (strong,nonatomic)FMDatabaseQueue * queue;
@end

@implementation OBBillManager
+(instancetype)sharedInstance{
    //单例创建数据库
    static OBBillManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[OBBillManager alloc]init];
        NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
        manager.dbPath = [doc stringByAppendingPathComponent:@"OBBillDatabase.sqlite"];
        manager.queue=[FMDatabaseQueue databaseQueueWithPath:manager.dbPath];
        [manager.queue inDatabase:^(FMDatabase *db) {
            NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(value double, createdDate datetime, location blob,locDescription text,category text,isOut bool);",@"BillsTable"];
            BOOL result = [db executeUpdate:sql];
            if (result) NSLog(@"创建%@成功",@"BillsTable");
            sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(dateOfDay datetime,sum double);",@"SumTable"];
            result = [db executeUpdate:sql];
            if (result) NSLog(@"创建%@成功",@"SumTable");
            NSLog(@"%@",manager.dbPath);
        }];
    });
    return manager;
}

- (BOOL)insertBill:(OBBill *)bill{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSData * locData=[NSKeyedArchiver archivedDataWithRootObject:bill.location];
        NSString * sql=[NSString stringWithFormat:@"insert into %@(value,createdDate,location,locDescription,category,isOut) VALUES(?,?,?,?,?,?);",@"BillsTable"];
        result=[db executeUpdate:sql,@(bill.value),bill.date,locData,bill.locDescription,bill.category,@(bill.isOut)];
    }];
    return result;
}

- (NSArray<OBBill *> *)billsSameDayAsDate:(NSDate *)date{
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSTimeInterval dayStartStamp=[[calendar startOfDayForDate:date] timeIntervalSince1970];
    NSTimeInterval dayEndStamp=dayStartStamp+60*60*24;
    NSMutableArray * resultArr=[[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<?);"];
        FMResultSet *resultSet = [db executeQuery:sql,@((double)dayStartStamp),@((double)dayEndStamp)];
        while ([resultSet next]) {
            OBBill * bill=[[OBBill alloc]initWithValue:[resultSet doubleForColumn:@"value"] Date:[resultSet dateForColumn:@"createdDate"] Location:nil AndLocationDescription:[resultSet stringForColumn:@"locDescription"] Category:[resultSet stringForColumn:@"category"] andIsOut:[resultSet boolForColumn:@"isOut"]];
            NSData * locData=[resultSet dataForColumn:@"location"];
            CLLocation * location=[NSKeyedUnarchiver unarchiveObjectWithData:locData];
            bill.location=location;
            [resultArr addObject:bill];
        }
        [resultSet close];
    }];
    return resultArr;
}

-(BOOL)updateSumOfDay:(NSDate *)date{
    NSArray * billArr = [[OBBillManager sharedInstance] billsSameDayAsDate:date];
    double daySpend=0;
    for (OBBill * bill in billArr) {
        daySpend-= bill.isOut?bill.value:-bill.value;
    }
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSTimeInterval dayStartStamp=[[calendar startOfDayForDate:date] timeIntervalSince1970];
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"insert into %@(dateOfDay,sum) VALUES(?,?);",@"SumTable"];
        result=[db executeUpdate:sql,@((double)dayStartStamp),@(daySpend)];
    }];
    return result;
}

-(double)sumOfDay:(NSDate *)date{
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSTimeInterval dayStartStamp=[[calendar startOfDayForDate:date] timeIntervalSince1970];
    __block double sum=0;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from SumTable where(dateOfDay==?);"];
        FMResultSet *resultSet = [db executeQuery:sql,@((double)dayStartStamp)];
        while ([resultSet next]) {
            sum=[resultSet doubleForColumn:@"sum"];
        }
        [resultSet close];
    }];
    return sum;
}

@end
