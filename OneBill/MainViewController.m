//
//  ViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Masonry.h>
#import "MainViewController.h"
#import "view/TodayCardView.h"
#import "view/OBMainButton.h"
#import "NewBillViewController.h"
#import "model/OBBillManager.h"
#import "BillDetailViewController.h"
#import "DaySummaryViewController.h"
#import "CheckBillsViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet TodayCardView *todayCardView;
@property (strong, nonatomic) OBMainButton * addBtn;
@property (strong, nonatomic) OBMainButton * checkBtn;
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
    self.todayCardView.labelNum.text=[NSString stringWithFormat:@"%+.2lf",[[OBBillManager sharedInstance] sumOfDay:[NSDate date]]];
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
    [self.checkBtn addTarget:self action:@selector(checkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //进入今日账单详情的手势
    UITapGestureRecognizer * tapForToday=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterTodayDetail)];
    UISwipeGestureRecognizer * swipeForToday=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(enterTodayDetail)];
    swipeForToday.direction=UISwipeGestureRecognizerDirectionUp;
    [self.todayCardView addGestureRecognizer:tapForToday];
    [self.todayCardView addGestureRecognizer:swipeForToday];
    //进入账单概况的手势
    UIView * summaryGestureView=[[UIView alloc]init];
    summaryGestureView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:summaryGestureView];
    [summaryGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.todayCardView.mas_top);
    }];
    UITapGestureRecognizer * tapForSummary=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterDaySummary)];
    UISwipeGestureRecognizer * swipeForSummary=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(enterDaySummary)];
    swipeForSummary.direction=UISwipeGestureRecognizerDirectionDown;
    [summaryGestureView addGestureRecognizer:tapForSummary];
    [summaryGestureView addGestureRecognizer:swipeForSummary];
    
}

-(void)enterTodayDetail{
    BillDetailViewController * vc=[[BillDetailViewController alloc]initWithBills:[[OBBillManager sharedInstance] billsSameDayAsDate:[NSDate date]] ];
    vc.date=[NSDate date];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)enterDaySummary{
    DaySummaryViewController * vc=[[DaySummaryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewBill{
    [self performSegueWithIdentifier:@"NBVC" sender:nil];
}

- (void)checkBtnClicked{
    CheckBillsViewController * vc=[[CheckBillsViewController alloc]initWithDate:[NSDate date]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
