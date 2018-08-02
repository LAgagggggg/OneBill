//
//  CheckBillsViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/26.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CheckBillsViewController.h"
#import "CategoryManagerViewController.h"
#import "model/CategoryManager.h"
#import "model/OBBillManager.h"
#import "view/OBDaySummaryCardView.h"
#import "view/OBTableViewCardCell.h"
#import "view/OBCategoryScrollView.h"
#import <masonry.h>

#define CellEdgeInset 8

@interface CheckBillsViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong,nonatomic)NSMutableArray<OBBill *>* billsArr;
@property (strong,nonatomic)OBCategoryScrollView * categoryScrollView;
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSString * currentCategory;
@end

@implementation CheckBillsViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self addObserver:self forKeyPath:@"categoryScrollView.currentCategory" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setUI{
    self.title=@"Bills";
    UIBarButtonItem * calendarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkBarCalendarBtn"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * moreBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barMoreBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked)];
    self.navigationItem.rightBarButtonItems=@[moreBtn,calendarBtn];
    //设置导航栏返回按钮
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.frame = CGRectMake(0, 0, 17,18);
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"returnBtn"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * returnBarBtn = [[UIBarButtonItem alloc]initWithCustomView:returnBtn];;
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[spaceItem,returnBarBtn];
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
        make.left.equalTo(self.view.mas_left).with.offset(30-CellEdgeInset);
        make.right.equalTo(self.view.mas_right).with.offset(-30+CellEdgeInset);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(8, 0, 20, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[OBTableViewCardCell class] forCellReuseIdentifier:reuseIdentifier];
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
    OBTableViewCardCell * cell=[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OBTableViewCardCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setCellWithBill:self.billsArr[indexPath.row] andStylePreference:OBTimeLibelWithDate];
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

@end
