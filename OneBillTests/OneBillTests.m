//
//  OneBillTests.m
//  OneBillTests
//
//  Created by LAgagggggg on 2018/8/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OBBillManager.h"

@interface OneBillTests : XCTestCase

@property (nonatomic, strong)  OBBillManager * billManager;

@end

@implementation OneBillTests

- (void)setUp {
    [super setUp];
    self.billManager=[OBBillManager sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.billManager=nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self.billManager billsSameMonthAsDate:[NSDate date] ofCategory:nil];
    }];
}

@end
