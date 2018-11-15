//
//  CategoryManager.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManager.h"

@interface CategoryManager()

@property (nonatomic, strong)  void(^categoriesEditedHandler)(void);

@end

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
            [manager.categoriesArr addObjectsFromArray:@[@"Meals",@"Drinks",@"Transports",@"DailyUse",@"Housing",@"Communication",@"Travel",@"Entertainment"]];
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
    if (self.categoriesEditedHandler) {
        self.categoriesEditedHandler();
    }
}

- (void)registerWriteToFileCallBack:(void(^)(void))handler{
    self.categoriesEditedHandler=handler;
}

@end
