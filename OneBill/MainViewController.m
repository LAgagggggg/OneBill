//
//  ViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "MainViewController.h"
#import "view/TodayCardView.h"
#import "view/OBMainButton.h"
#import "NewBillViewController.h"
#import <Masonry.h>

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet TodayCardView *todayCardView;
@property (strong, nonatomic) OBMainButton * addBtn;
@property (strong, nonatomic) OBMainButton * checkBtn;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
    self.addBtn=[[OBMainButton alloc]initWithType:OBButtonTypeAdd];
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.todayCardView.mas_bottom);
        make.height.equalTo(@(66));
        make.width.equalTo(@(200));
    }];
    [self.addBtn addTarget:self action:@selector(addNewBill) forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn=[[OBMainButton alloc]initWithType:OBButtonTypeCheck];
    [self.view addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.addBtn.mas_bottom).with.offset(18);
        make.height.equalTo(@(42));
        make.width.equalTo(@(200));
    }];
    
}

- (void)addNewBill{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self performSegueWithIdentifier:@"NBVC" sender:nil];
}


@end
