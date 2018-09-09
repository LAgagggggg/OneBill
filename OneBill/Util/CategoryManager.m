//
//  CategoryManager.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManager.h"

@implementation CategoryManager

+(CategoryManager *)sharedInstance{
    static CategoryManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[CategoryManager alloc]init];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [path objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"categoryArr.plist"];
        manager.categoriesArr=[NSMutableArray arrayWithContentsOfFile:plistPath];
        if (manager.categoriesArr==nil) {
            manager.categoriesArr=[[NSMutableArray alloc]init];
            [manager.categoriesArr addObjectsFromArray:@[@"DailyUse",@"Housing",@"Communication",@"Meal",@"Travel",@"Entertainment"]];
            [manager.categoriesArr writeToFile:plistPath atomically:YES];
        }
    });
    return manager;
}

- (BOOL)replaceCategory:(NSString *)old withNewCategory:(NSString *)new{
    if ([self.categoriesArr containsObject:new]) {
        return NO;
    }
    else{
        [self.categoriesArr replaceObjectAtIndex:[self.categoriesArr indexOfObject:old] withObject:new];
        return YES;
    }
}

-(void)writeToFile{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"categoryArr.plist"];
    [self.categoriesArr writeToFile:plistPath atomically:YES];
}
@end
