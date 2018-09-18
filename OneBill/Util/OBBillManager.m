//
//  OBBillManager.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/22.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBBillManager.h"
#import "CategoryManager.h"
#import <FMDB.h>

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
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<?) ORDER BY createdDate DESC;;"];
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
        NSString * sql=nil;
        FMResultSet * resultSet=nil;
        if (category) {
            sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<? AND category==?) ORDER BY createdDate ASC;"];
            resultSet = [db executeQuery:sql,@((double)monthStartStamp),@((double)monthEndStamp),category];
        }
        else{
            sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<?) ORDER BY createdDate ASC;"];
            resultSet = [db executeQuery:sql,@((double)monthStartStamp),@((double)monthEndStamp)];
        }
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

- (BOOL)editBillOfDate:(NSDate *)date Value:(double)value withBill:(OBBill *)newBill{
    __block BOOL result;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"update BillsTable set value=?,createdDate=?,location=?,locDescription=?,category=?,isOut=? where(createdDate==? AND value==?);"];
        NSData * locData=[NSKeyedArchiver archivedDataWithRootObject:newBill.location];
        result=[db executeUpdate:sql,@(newBill.value),newBill.date,locData,newBill.locDescription,newBill.category,@(newBill.isOut),date,@(value)];
    }];
    return result;
}

-(BOOL)updateSumOfDay:(NSDate *)date{
    NSArray * billArr = [[OBBillManager sharedInstance] billsSameDayAsDate:date];
    double daySpend=0;
    NSCalendar * calendar=[NSCalendar currentCalendar];
    NSTimeInterval dayStartStamp=[[calendar startOfDayForDate:date] timeIntervalSince1970];
    __block BOOL result;
    if (billArr.count==0) {//如果没有账单则不记录(并删除)该天summary
        [self.queue inDatabase:^(FMDatabase *db) {
            NSString * sql=@"select count(*) from sumTable where(dateOfDay==?);";
            NSInteger count=[db intForQuery:sql,@((double)dayStartStamp)];
            if (count) {
                sql=[NSString stringWithFormat:@"delete from %@ where(dateOfDay==?);",@"SumTable"];
                result=[db executeUpdate:sql,@((double)dayStartStamp)];
            }
        }];
    }
    else{
        for (OBBill * bill in billArr) {
            daySpend-= bill.isOut?bill.value:-bill.value;
        }
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
    }
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

- (double)predictValueWithCategory:(NSString *)category Date:(NSDate *)date AndLocation:(CLLocation *)location{
    double locationMatchD=500;
    double timeMatchD=3600;
    double fetchRange=60*60*24*30;//三十天
    int valuePrecision=10;
    double becomePredictValueStandard=0.6;
    int billEnoughForPredict=6;
    /*
     首先取出之前一段时间的数据
     将其归类为都相符、仅时间相符以及仅地点相符
     然后首先尝试从都相符的数据中根据精度获取预测值，比如有百分之60的账单值为10+，精度为10，则返回预测值为10；
    */
    //取出数据
    NSTimeInterval fetchEndStamp=[date timeIntervalSince1970];
    NSMutableArray * billsArr=[[NSMutableArray alloc]init];
    double predictValue=0;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<? AND category==? AND isOut==1);"];
        FMResultSet *resultSet = [db executeQuery:sql,@((double)fetchEndStamp-fetchRange),@((double)fetchEndStamp-60*60*23),category];
        while ([resultSet next]) {
            OBBill * bill=[[OBBill alloc]initWithValue:[resultSet doubleForColumn:@"value"] Date:[resultSet dateForColumn:@"createdDate"] Location:nil AndLocationDescription:[resultSet stringForColumn:@"locDescription"] Category:[resultSet stringForColumn:@"category"] andIsOut:[resultSet boolForColumn:@"isOut"]];
            NSData * locData=[resultSet dataForColumn:@"location"];
            CLLocation * location=[NSKeyedUnarchiver unarchiveObjectWithData:locData];
            bill.location=location;
            [billsArr addObject:bill];
        }
        [resultSet close];
    }];
    if(billsArr.count<billEnoughForPredict){//数据不足
        return NAN;
    }
    //归类
    NSMutableArray<OBBill *> * timeMatchArr=[[NSMutableArray alloc]init];
    NSMutableArray<OBBill *> * locationMatchArr=[[NSMutableArray alloc]init];
    NSMutableArray<OBBill *> * bothMatchArr=[[NSMutableArray alloc]init];
    for (OBBill * bill in billsArr) {
        BOOL timeMatch=NO;
        BOOL locationMatch=NO;
        NSTimeInterval targetTimeStamp=[bill.date timeIntervalSince1970];
        if (targetTimeStamp>=fetchEndStamp-timeMatchD && targetTimeStamp<=fetchEndStamp+timeMatchD) {
            [timeMatchArr addObject:bill];
            timeMatch=YES;
        }
        if (bill.location && location) {
            if ([bill.location distanceFromLocation:location]<=locationMatchD) {
                [locationMatchArr addObject:bill];
                locationMatch=YES;
            }
            
        }
        if (timeMatch && locationMatch) {
            [bothMatchArr addObject:bill];
        }
    }
    NSMutableDictionary * predictDict=[[NSMutableDictionary alloc]init];
    //根据bothMatchArr预测
    if (bothMatchArr.count>=billEnoughForPredict) {
        for (OBBill * bill in bothMatchArr) {
            NSNumber * count=[predictDict objectForKey:@(@(bill.value).integerValue/valuePrecision)];
            if (count==nil) {
                [predictDict setObject:@(1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
            else{
                [predictDict setObject:@(count.integerValue+1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
        }
        int predictLimit=(int)(bothMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDict keyEnumerator];
        for ( NSNumber * key in enumeratorKey) {
            NSNumber * count=[predictDict objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictValue=key.integerValue*10;
                return predictValue;
            }
        }
    }
    //根据TimeMatchArr预测
    if(timeMatchArr.count>=billEnoughForPredict && timeMatchArr.count>=2*bothMatchArr.count){
        [predictDict removeAllObjects];
        for (OBBill * bill in timeMatchArr) {
            NSNumber * count=[predictDict objectForKey:@(@(bill.value).integerValue/valuePrecision)];
            if (count==nil) {
                [predictDict setObject:@(1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
            else{
                [predictDict setObject:@(count.integerValue+1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
        }
        int predictLimit=(int)(timeMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDict keyEnumerator];
        for ( NSNumber * key in enumeratorKey) {
            NSNumber * count=[predictDict objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictValue=key.integerValue*10;
                return predictValue;
            }
        }
    }
    //根据locationMatchArr预测
    if(locationMatchArr.count>=billEnoughForPredict && locationMatchArr.count>=2*bothMatchArr.count){
        [predictDict removeAllObjects];
        for (OBBill * bill in locationMatchArr) {
            NSNumber * count=[predictDict objectForKey:@(@(bill.value).integerValue/valuePrecision)];
            if (count==nil) {
                [predictDict setObject:@(1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
            else{
                [predictDict setObject:@(count.integerValue+1) forKey:@(@(bill.value).integerValue/valuePrecision)];
            }
        }
        int predictLimit=(int)(locationMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDict keyEnumerator];
        for ( NSNumber * key in enumeratorKey) {
            NSNumber * count=[predictDict objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictValue=key.integerValue*10;
                return predictValue;
            }
        }
    }
    //若还无结果则取bothArr的平均值
    if (bothMatchArr.count) {
        predictValue=0;
        for (OBBill * bill in bothMatchArr) {
            predictValue+=bill.value;
        }
        predictValue/= bothMatchArr.count?bothMatchArr.count:1;
        predictValue=((int)predictValue)/valuePrecision*10;
        return predictValue;
    }
    else{
        return NAN;
    }
}

- (nullable NSString *)predictCategoryWithDate:(NSDate *)date Location:(CLLocation *)location{
    double locationMatchD=500;
    double timeMatchD=3600;
    double fetchRange=60*60*24*7;//七天
    double becomePredictValueStandard=0.6;
    int billEnoughForPredict=1;
    /*
     首先取出之前一段时间的数据
     将其归类为都相符、仅时间相符以及仅地点相符
     并依据这三类进行预测
     */
    //取出数据
    NSTimeInterval fetchEndStamp=[date timeIntervalSince1970];
    NSMutableArray * billsArr=[[NSMutableArray alloc]init];
    NSString * predictCategory=nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql=[NSString stringWithFormat:@"select * from BillsTable where(createdDate>=? AND createdDate<?  AND isOut==1);"];
        FMResultSet *resultSet = [db executeQuery:sql,@((double)fetchEndStamp-fetchRange),@((double)fetchEndStamp-60*60*23)];
        while ([resultSet next]) {
            OBBill * bill=[[OBBill alloc]initWithValue:[resultSet doubleForColumn:@"value"] Date:[resultSet dateForColumn:@"createdDate"] Location:nil AndLocationDescription:[resultSet stringForColumn:@"locDescription"] Category:[resultSet stringForColumn:@"category"] andIsOut:[resultSet boolForColumn:@"isOut"]];
            NSData * locData=[resultSet dataForColumn:@"location"];
            CLLocation * location=[NSKeyedUnarchiver unarchiveObjectWithData:locData];
            bill.location=location;
            [billsArr addObject:bill];
        }
        [resultSet close];
    }];
    if(billsArr.count<billEnoughForPredict){//数据不足
        return nil;
    }
    //归类
    NSMutableArray<OBBill *> * timeMatchArr=[[NSMutableArray alloc]init];
    NSMutableArray<OBBill *> * locationMatchArr=[[NSMutableArray alloc]init];
    NSMutableArray<OBBill *> * bothMatchArr=[[NSMutableArray alloc]init];
    for (OBBill * bill in billsArr) {
        BOOL timeMatch=NO;
        BOOL locationMatch=NO;
        NSTimeInterval targetTimeStamp=[bill.date timeIntervalSince1970];
        if (targetTimeStamp>=fetchEndStamp-timeMatchD && targetTimeStamp<=fetchEndStamp+timeMatchD) {
            [timeMatchArr addObject:bill];
            timeMatch=YES;
        }
        if (bill.location && location) {
            if ([bill.location distanceFromLocation:location]<=locationMatchD) {
                [locationMatchArr addObject:bill];
                locationMatch=YES;
            }
            
        }
        if (timeMatch && locationMatch) {
            [bothMatchArr addObject:bill];
        }
    }
    NSMutableDictionary * predictDict=[[NSMutableDictionary alloc]init];
    NSMutableDictionary * predictDictForBoth=[[NSMutableDictionary alloc]init];
    //根据bothMatchArr预测
    if (bothMatchArr.count>=billEnoughForPredict) {
        for (OBBill * bill in bothMatchArr) {
            NSNumber * count=[predictDictForBoth objectForKey:bill.category];
            if (count==nil) {
                [predictDictForBoth setObject:@(1) forKey:bill.category];
            }
            else{
                [predictDictForBoth setObject:@(count.integerValue+1) forKey:bill.category];
            }
        }
        int predictLimit=(int)(bothMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDictForBoth keyEnumerator];
        for ( NSString * key in enumeratorKey) {
            NSNumber * count=[predictDictForBoth objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictCategory=key;
                return predictCategory;
            }
        }
    }
    //根据locationMatchArr预测
    if(locationMatchArr.count>=billEnoughForPredict && locationMatchArr.count>=2*bothMatchArr.count){
        [predictDict removeAllObjects];
        for (OBBill * bill in locationMatchArr) {
            NSNumber * count=[predictDict objectForKey:bill.category];
            if (count==nil) {
                [predictDict setObject:@(1) forKey:bill.category];
            }
            else{
                [predictDict setObject:@(count.integerValue+1) forKey:bill.category];
            }
        }
        int predictLimit=(int)(locationMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDict keyEnumerator];
        for ( NSString * key in enumeratorKey) {
            NSNumber * count=[predictDict objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictCategory=key;
                return predictCategory;
            }
        }
    }
    //根据TimeMatchArr预测
    if(timeMatchArr.count>=billEnoughForPredict && timeMatchArr.count>=2*bothMatchArr.count){
        [predictDict removeAllObjects];
        for (OBBill * bill in timeMatchArr) {
            NSNumber * count=[predictDict objectForKey:bill.category];
            if (count==nil) {
                [predictDict setObject:@(1) forKey:bill.category];
            }
            else{
                [predictDict setObject:@(count.integerValue+1) forKey:bill.category];
            }
        }
        int predictLimit=(int)(timeMatchArr.count*becomePredictValueStandard);
        NSEnumerator * enumeratorKey = [predictDict keyEnumerator];
        for ( NSString * key in enumeratorKey) {
            NSNumber * count=[predictDict objectForKey:key];
            if (count.integerValue>=predictLimit) {
                predictCategory=key;
                return predictCategory;
            }
        }
    }
    //若还无结果则取bothArr的中出现最多的category
    if (predictDictForBoth.count) {
        NSEnumerator * enumeratorKey = [predictDictForBoth keyEnumerator];
        NSNumber * maxValue=0;
        NSString * keyForMax=nil;
        for ( NSString * key in enumeratorKey) {
            NSNumber * count=[predictDictForBoth objectForKey:key];
            if (count.integerValue>maxValue.integerValue) {
                keyForMax=key;
            }
        }
        return keyForMax;
    }
    return predictCategory;
}
@end
