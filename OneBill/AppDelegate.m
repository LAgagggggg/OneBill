//
//  AppDelegate.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "AppDelegate.h"
#import  "OBBillManager.h"
#import "MainViewController.h"
#import "NewOrEditBillViewController.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bugly startWithAppId:@"42bb66e033"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.layer.speed=0.1;
    UINavigationController * navVC=[[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    [self.window setRootViewController:navVC];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    [self createShortCutItem];
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    if (shortcutItem) {
        //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if([shortcutItem.type isEqualToString:@"com.ookkee.OneBill.add"]){
            NewOrEditBillViewController * addVC = [[NewOrEditBillViewController alloc] init];
            UINavigationController * naVC=(UINavigationController *)self.window.rootViewController;
            [naVC pushViewController:addVC animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    if (shortcutItem) {
        if([shortcutItem.type isEqualToString:@"com.ookkee.OneBill.add"]){
            NewOrEditBillViewController * addVC = [[NewOrEditBillViewController alloc] init];
            UINavigationController * naVC=(UINavigationController *)self.window.rootViewController;
            [naVC pushViewController:addVC animated:YES];
        }
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}

- (void)createShortCutItem
{
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc] initWithType:@"com.ookkee.OneBill.add" localizedTitle:@"Add Bill" localizedSubtitle:nil icon:icon userInfo:nil];
    [UIApplication sharedApplication].shortcutItems = @[item];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
