//
//  OneBillUITests.m
//  OneBillUITests
//
//  Created by LAgagggggg on 2018/8/24.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface OneBillUITests : XCTestCase

@end

@implementation OneBillUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [[[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"MainView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[app.scrollViews.otherElements containingType:XCUIElementTypeStaticText identifier:@"meals"] childrenMatchingType:XCUIElementTypeButton].element tap];
    
    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Add new Bill"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeTextField].element tap];
    
    XCUIElement *key = app/*@START_MENU_TOKEN@*/.keys[@"6"]/*[[".keyboards.keys[@\"6\"]",".keys[@\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [key tap];
    [key tap];
    [key tap];
    [element tap];
    [app.buttons[@"confirmBtn"] tap];
    
    
}

@end
