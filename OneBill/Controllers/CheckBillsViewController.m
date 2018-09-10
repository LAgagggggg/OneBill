//
//  CheckBillsViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/26.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Masonry.h>
#import "CheckBillsViewController.h"
#import "CategoryManagerViewController.h"
#import  "CategoryManager.h"
#import  "OBBillManager.h"
#import  "OBDaySummaryCardView.h"
#import  "OBDetailCardCell.h"
#import  "OBCategoryScrollView.h"

#define CellEdgeInset 8

@interface CheckBillsViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (strong,nonatomic)NSMutableArray<OBBill *>* billsArr;
@property (strong,nonatomic)OBCategoryScrollView * categoryScrollView;
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSString * currentCategory;
@property (strong,nonatomic)UITapGestureRecognizer * textFieldResignTap;

@end

@implementation CheckBillsViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self addObserver:self forKeyPath:@"categoryScrollView.currentCategory" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"categoryScrollView.currentCategory"];
}

-(void)setUI{
    self.title=@"Bills";
    //导航栏右侧按钮
//    UIBarButtonItem * calendarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkBarCalendarBtn"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * moreBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barMoreBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked)];
    self.navigationItem.rightBarButtonItems=@[moreBtn];
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnBtn"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    self.navigationItem.leftBarButtonItem=returnBarBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    //顶部选择category
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,157)];
    [self.view addSubview:topView];
    topView.backgroundColor=self.view.backgroundColor;
    topView.layer.shadowColor=[UIColor grayColor].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0, 3);
    topView.layer.shadowOpacity = 0.1;
    topView.layer.shadowRadius = 12;
    self.categoryScrollView=[[OBCategoryScrollView alloc]initWithCategorys:[CategoryManager sharedInstance].categoriesArr];
    self.categoryScrollView.alwaysShowSum=YES;
    [topView addSubview:self.categoryScrollView];
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(88));
    }];
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:topView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(8, 0, 20, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[OBDetailCardCell class] forCellReuseIdentifier:reuseIdentifier];
    //用于注销firstResponder
    self.textFieldResignTap=[[UITapGestureRecognizer alloc]init];
    [self.view addGestureRecognizer:self.textFieldResignTap];
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.currentCategory=[CategoryManager sharedInstance].categoriesArr[0];
        self.billsArr=[[OBBillManager sharedInstance]billsSameMonthAsDate:date ofCategory:self.currentCategory].mutableCopy;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OBDetailCardCell * cell=[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OBDetailCardCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setCellWithBill:self.billsArr[indexPath.row] andStylePreference:OBTimeLibelWithDate];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"categoryScrollView.currentCategory"]&&object==self) {
        self.currentCategory=self.categoryScrollView.currentCategory;
        self.billsArr=[[OBBillManager sharedInstance]billsSameMonthAsDate:[NSDate date] ofCategory:self.currentCategory].mutableCopy;
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [self.tableView reloadData];
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    for (UIView *subview in tableView.subviews)
//    {
//        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
//        {
//            subview.backgroundColor=[UIColor clearColor];
//            subview.subviews[0].layer.cornerRadius=10.f;
//            subview.subviews[0].layer.masksToBounds=YES;
//            CGRect frame=subview.subviews[0].frame;
//            frame.size.width-=CellEdgeInset;
//            subview.subviews[0].frame=frame;
//            
//        }
//    }
//    return YES;
//}

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreBtnClicked{
    CategoryManagerViewController * vc=[[CategoryManagerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self.categoryScrollView.addTextField isFirstResponder]) {
        [self.categoryScrollView.addTextField resignFirstResponder];
    }
    return YES;
}

@end
