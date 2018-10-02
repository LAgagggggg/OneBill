//
//  ViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/17.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Masonry.h>
#import "MainViewController.h"
#import  "TodayCardTransitionAnimationPush.h"
#import  "TodayCardTransitionAnimationPop.h"
#import  "SummaryToDetailTransitionAnimationPush.h"
#import  "SummaryToDetailTransitionAnimationPop.h"
#import  "MainToSummaryTransitionAnimationPush.h"
#import  "MainToSummaryTransitionAnimationPop.h"
#import "NewOrEditBillViewController.h"
#import  "TodayCardView.h"
#import  "OBMainButton.h"
#import  "OBBillManager.h"
#import "BillDetailViewController.h"
#import "DaySummaryViewController.h"
#import "CheckBillsViewController.h"
#import  "OBInteractiveTransition.h"
#import "TodaySayingView.h"

@interface MainViewController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) OBMainButton * checkBtn;
@property (strong, nonatomic) TodaySayingView * sayingView;
@property double todaySpend;
@property (nonatomic, strong) OBInteractiveTransition *interactivePushToDetail;
@property (nonatomic, strong) OBInteractiveTransition *interactivePushToSummary;
@property (nonatomic, strong) BillDetailViewController *todayDetailVC;
@property (nonatomic, strong) DaySummaryViewController *summaryVC;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate=self;
    [self setUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIGraphicsBeginImageContextWithOptions(self.todayCardView.frame.size, NO, 0);
    [self.todayCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.animationImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)viewWillAppear:(BOOL)animated{
    //刷新今日花销
    self.todayCardView.labelNum.text=[NSString stringWithFormat:@"%+.2lf",[[OBBillManager sharedInstance] sumOfDay:[NSDate date]]];
}

- (void)setUI{
    double screenHeightAdaptRatio=[UIScreen mainScreen].bounds.size.height/667.0;
    //导航栏返回按钮
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"returnBtn"];
//    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"returnBtn"];
//    backItem.imageInsets=UIEdgeInsetsMake(0, 100, 20, 0);
//    self.navigationItem.backBarButtonItem = backItem;
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    //导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
    //顶部文字
    self.sayingView=[[TodaySayingView alloc]initWithLine:@[@"One Bill A Day",@"Keeps worries away."]];
    [self.view addSubview:self.sayingView];
    [self.sayingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(130*screenHeightAdaptRatio);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(60));
        make.width.equalTo(self.view.mas_width);
    }];
    //今日卡片
    self.todayCardView=[[TodayCardView alloc]init];
    [self.view addSubview:self.todayCardView];
    [self.todayCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.top.equalTo(self.sayingView.mas_top).with.offset(122*screenHeightAdaptRatio);
        make.height.equalTo(@(229*screenHeightAdaptRatio));
    }];
    //按钮
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
    [self.todayCardView addGestureRecognizer:tapForToday];
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
    UIPanGestureRecognizer * panForTransition=[[UIPanGestureRecognizer alloc]init];
    panForTransition.delegate=self;
    [summaryGestureView addGestureRecognizer:tapForSummary];
    [self.view addGestureRecognizer:panForTransition];
    //上划转场动画 -今日详情
    self.interactivePushToDetail=[OBInteractiveTransition interactiveTransitionWithTransitionType:OBInteractiveTransitionTypePush GestureDirection:OBInteractiveTransitionGestureDirectionUp];
    typeof(self)weakSelf = self;
    self.interactivePushToDetail.pushConifg = ^{
        [weakSelf enterTodayDetail];
    };
    self.interactivePushToDetail.vc=self.navigationController;
    [self.interactivePushToDetail setPanGestureRecognizer:panForTransition];
    //下拉转场动画 -summary界面
    self.interactivePushToSummary=[OBInteractiveTransition interactiveTransitionWithTransitionType:OBInteractiveTransitionTypePush GestureDirection:OBInteractiveTransitionGestureDirectionDown];
    self.interactivePushToSummary.pushConifg = ^{
        [weakSelf enterDaySummary];
    };
    self.interactivePushToSummary.vc=self.navigationController;
    [self.interactivePushToSummary setPanGestureRecognizer:panForTransition];
}

-(void)enterTodayDetail{
    self.todayDetailVC=[[BillDetailViewController alloc]initWithBills:[[OBBillManager sharedInstance] billsSameDayAsDate:[NSDate date]] ];
    self.todayDetailVC.date=[NSDate date];
    [self.navigationController pushViewController:self.todayDetailVC animated:YES];
}

-(void)enterDaySummary{
    self.summaryVC=[[DaySummaryViewController alloc]init];
    [self.navigationController pushViewController:self.summaryVC animated:YES];
}

- (void)addNewBill{
    NewOrEditBillViewController * addVC=[[NewOrEditBillViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)checkBtnClicked{
    CheckBillsViewController * vc=[[CheckBillsViewController alloc]initWithDate:[NSDate date]];
    [self.navigationController pushViewController:vc animated:YES];
}

//碰到按钮时不触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - transitionAnimation Control

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if ([fromVC isEqual:self] && [toVC isMemberOfClass:[BillDetailViewController class]]) {//主界面至今日详情
        return [[TodayCardTransitionAnimationPush alloc]init];
    }
    else if([toVC isEqual:self] && [fromVC isMemberOfClass:[BillDetailViewController class]]){//今日详情返回主界面
        return [[TodayCardTransitionAnimationPop alloc]init];
    }
    else if([fromVC isEqual:self] && [toVC isMemberOfClass:[DaySummaryViewController class]]){//主界面至概况界面
        return [[MainToSummaryTransitionAnimationPush alloc]init];
    }
    else if([toVC isEqual:self] && [fromVC isMemberOfClass:[DaySummaryViewController class]]){//概况界面返回主界面
        return [[MainToSummaryTransitionAnimationPop alloc]init];
    }
    else if([fromVC isMemberOfClass:[DaySummaryViewController class]] && [toVC isMemberOfClass:[BillDetailViewController class]]){
        //概况界面至详情界面
        return [[SummaryToDetailTransitionAnimationPush alloc]init];
    }
    else if([fromVC isMemberOfClass:[BillDetailViewController class]] && [toVC isMemberOfClass:[DaySummaryViewController class]]){
        //详情界面返回概况界面
        SummaryToDetailTransitionAnimationPop * pop=[[SummaryToDetailTransitionAnimationPop alloc]init];
        BillDetailViewController * vc=(BillDetailViewController *)fromVC;
        pop.interactivePop=vc.interactivePop;
        return pop;
    }
    else{
        return nil;
    }
}

//自定义转场动画手势
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if ([animationController isMemberOfClass:[TodayCardTransitionAnimationPush class]]){//进入今日详情
        return self.interactivePushToDetail.interation?self.interactivePushToDetail:nil;
    }
    if ([animationController isMemberOfClass:[MainToSummaryTransitionAnimationPush class]]){//进入概况
        return self.interactivePushToSummary.interation?self.interactivePushToSummary:nil;
    }
    else if ([animationController isMemberOfClass:[TodayCardTransitionAnimationPop class]]){//从今日详情返回
        return self.todayDetailVC.interactivePop.interation?self.todayDetailVC.interactivePop:nil;
    }
    else if ([animationController isMemberOfClass:[MainToSummaryTransitionAnimationPop class]]){//从概况返回
        return self.summaryVC.interactivePop.interation?self.summaryVC.interactivePop:nil;
    }
    else if ([animationController isMemberOfClass:[SummaryToDetailTransitionAnimationPop class]]){//从概况至详情
        SummaryToDetailTransitionAnimationPop * pop=animationController;
        return pop.interactivePop.interation?pop.interactivePop:nil;
    }
    else{
        return nil;
    }
}

@end
