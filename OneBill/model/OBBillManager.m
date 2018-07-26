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

- (BOOL)removeBill:(OBBill *)bill{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSTimeInterval dateInterval=[bill.date timeIntervalSince1970];
        NSString * sql=[NSString stringWithFormat:@"delete from %@ where(value==? AND createdDate==?);",@"BillsTable"];
        result=[db executeUpdate:sql,@(bill.value),@((double)dateInterval)];
    }];
    return result;
}

- (NSArray<OBBill *> *)billsSameDayAsDate:(NSDate *)date{
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSTimeInterval dayStartStamp=[[calendar startOfDayForDate:date] timeIntervalSince1970];
    NSTimeInterval dayEndStamp=dayStartStamp+60*60*24;
    NSMutableArray * resultArr=[[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<?) ORDER BY createdDate ASC;;"];
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

- (NSArray<OBBill *> *)billsSameMonthAsDate:(NSDate *)date ofCategory:(NSString *)category{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents * components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    [components setMonth:([components month] + 1)];
    NSDate *nextMonth = [cal dateFromComponents:components];
    NSTimeInterval monthStartStamp=[thisMonth timeIntervalSince1970];
    NSTimeInterval monthEndStamp=[nextMonth timeIntervalSince1970];
    NSMutableArray * resultArr=[[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<? AND category==?) ORDER BY createdDate ASC;;"];
        FMResultSet *resultSet = [db executeQuery:sql,@((double)monthStartStamp),@((double)monthEndStamp),category];
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
        NSString * sql=@"select count(*) from sumTable where(dateOfDay==?);";
        NSInteger count=[db intForQuery:sql,@((double)dayStartStamp)];
        if (count) {
            sql=[NSString stringWithFormat:@"update %@ set sum=? where(dateOfDay==?);",@"SumTable"];
            result=[db executeUpdate:sql,@(daySpend),@((double)dayStartStamp)];
        }
        else{
            sql=[NSString stringWithFormat:@"insert into %@(dateOfDay,sum) VALUES(?,?);",@"SumTable"];
            result=[db executeUpdate:sql,@(dayStartStamp),@(daySpend)];
        }
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

- (double)sumOfCategory:(NSString *)category InMonthOfDate:(NSDate *)date{
    NSArray * tempArr=[self billsSameMonthAsDate:date ofCategory:category];
    double sum=0;
    for (OBBill * bill in tempArr) {
        sum-= bill.isOut?bill.value:-bill.value;
    }
    return sum;
}

-(NSArray<OBDaySummary *> *)fetchDaySummaryFromIndex:(NSInteger)index WithAmount:(NSInteger)amount{
    NSMutableArray * summaryArr=[[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSUInteger count = [db intForQuery:@"select count(*) from sumTable;"];
        NSInteger sqlFetchFromIndex=count-amount-index;
        NSInteger actualAmount=amount;
        if (sqlFetchFromIndex<0) {
            sqlFetchFromIndex=0;
            actualAmount=count-index;
        }
        NSString * sql=[NSString stringWithFormat:@"select * from sumTable ORDER BY dateOfDay ASC LIMIT %ld,%d;",(long)sqlFetchFromIndex,(int)actualAmount];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            OBDaySummary * summary=[[OBDaySummary alloc]init];
            summary.date=[resultSet dateForColumn:@"dateOfDay"];
            summary.sum=[resultSet doubleForColumn:@"sum"];
            [summaryArr addObject:summary];
        }
        [resultSet close];
    }];
    return summaryArr;
}
@end
