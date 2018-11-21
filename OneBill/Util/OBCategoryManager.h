//
//  OBCategoryManager.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBCategoryManager : NSObject

@property (nonatomic, strong)  NSMutableArray<NSString *> * categoriesArr;

+ (OBCategoryManager *)sharedInstance;
- (BOOL)replaceCategory:(NSString *)old withNewCategory:(NSString *)new;
- (void)writeToFile;
- (void)registerWriteToFileCallBack:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
