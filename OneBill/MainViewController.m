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
#import "model/OBBillManager.h"
#import "BillDetailViewController.h"
#import <Masonry.h>

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet TodayCardView *todayCardView;
@property (strong, nonatomic) OBMainButton * addBtn;
@property (strong, nonatomic) OBMainButton * checkBtn;
@property (strong, nonatomic) NSArray * todayBillsArr;
@property double todaySpend;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    //刷新今日花销
    self.todayBillsArr = [[OBBillManager sharedInstance] billsSameDayAsDate:[NSDate date]];
    self.todaySpend=0;
    for (OBBill * bill in self.todayBillsArr) {
        self.todaySpend-= bill.isOut?bill.value:-bill.value;
    }
    self.todayCardView.labelNum.text=[NSString stringWithFormat:@"%+.2lf",self.todaySpend];
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
    //进入今日账单详情的手势
    UITapGestureRecognizer * tapForToday=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterTodayDetail)];
    UISwipeGestureRecognizer * swipeForToday=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(enterTodayDetail)];
    swipeForToday.direction=UISwipeGestureRecognizerDirectionUp;
    [self.todayCardView addGestureRecognizer:tapForToday];
    [self.todayCardView addGestureRecognizer:swipeForToday];
}

-(void)enterTodayDetail{
    BillDetailViewController * vc=[[BillDetailViewController alloc]initWithBills:self.todayBillsArr];
    vc.date=[NSDate date];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewBill{
    [self performSegueWithIdentifier:@"NBVC" sender:nil];
}


@end
