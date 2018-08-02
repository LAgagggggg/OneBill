//
//  CategoryManager.h
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryManager : NSObject

@property (strong,nonatomic) NSMutableArray<NSString *> * categoriesArr;
+ (CategoryManager *)sharedInstance;
- (BOOL)replaceCategory:(NSString *)old withNewCategory:(NSString *)new;
- (void)writeToFile;
@end

NS_ASSUME_NONNULL_END
