//
//  ViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "MainViewController.h"
#import "view/TodayCardView.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet TodayCardView *todayCardView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}


@end
