//
//  DaySummaryViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//
#import <masonry.h>
#import "BillDetailViewController.h"
#import "DaySummaryViewController.h"
#import "view/OBDaySummaryTableViewCell.h"
#import "model/OBBillManager.h"

#define DarkCyanColor [UIColor colorWithRed:109/255.0 green:218/255.0 blue:226/255.0 alpha:1]
#define commonCellHeight 148
#define todayCellHeight 180
#define CellEdgeInset 8
#define FetchEachTime 20
#define TableViewRefreshInset 60

@interface DaySummaryViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray<OBDaySummary *> * summaryArr;
@property (strong,nonatomic)UILabel * todaySumLabel;
@property(strong,nonatomic)UIActivityIndicatorView *reloadIndicator;
@property NSInteger fetchIndex;
@property BOOL fetchStopFlag;
@property BOOL isInserting;
@end

@implementation DaySummaryViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchIndex=0;
    self.isInserting=YES;
    [[OBBillManager sharedInstance]updateSumOfDay:[NSDate date]];
    self.summaryArr=[[NSMutableArray alloc]init];
    NSArray * tempArr=[NSMutableArray arrayWithArray:[[OBBillManager sharedInstance] fetchDaySummaryFromIndex:self.fetchIndex WithAmount:FetchEachTime]];
    [self.summaryArr addObjectsFromArray:tempArr];
    self.fetchIndex+=tempArr.count;
    self.fetchStopFlag= tempArr.count==FetchEachTime? NO:YES;
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.summaryArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.summaryArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isInserting=NO;
    });
}

-(void)setUI{
    self.title=@"Bills";
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnBtn"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    self.navigationItem.leftBarButtonItem=returnBarBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    //导航栏右侧按钮
    UIBarButtonItem * calendarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"summaryBarCalendarBtn"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem=calendarBtn;
    //顶部阴影
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    UIView * shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, rectNav.size.width, rectStatus.size.height+rectNav.size.height)];
    [self.view addSubview:shadowView];
    shadowView.backgroundColor=self.view.backgroundColor;
    shadowView.layer.shadowColor=[UIColor grayColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    shadowView.layer.shadowOpacity = 0.1;
    shadowView.layer.shadowRadius = 12;
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shadowView.mas_bottom);
        make.left.equalTo(self.view.mas_left).with.offset(30-CellEdgeInset);
        make.right.equalTo(self.view.mas_right).with.offset(-30+CellEdgeInset);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[OBDaySummaryTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view bringSubviewToFront:shadowView];
    self.tableView.estimatedRowHeight=commonCellHeight;
}

- (void)setTodayCell:(UITableViewCell *)cell{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    UIView * todayView=[[UIView alloc]init];
    todayView.backgroundColor=DarkCyanColor;
    todayView.layer.cornerRadius=10.f;
    todayView.layer.shadowColor=[UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1].CGColor;
    todayView.layer.shadowOffset = CGSizeMake(0, 6);
    todayView.layer.shadowOpacity = 0.3;
    todayView.layer.shadowRadius = 8;
    [cell.contentView addSubview:todayView];
    [todayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).with.offset(CellEdgeInset);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-CellEdgeInset);
        make.top.equalTo(cell.contentView.mas_top).with.offset(36);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-CellEdgeInset);
    }];
    CGRect frame=cell.selectedBackgroundView.frame;
    frame.origin.x+=CellEdgeInset;
    frame.origin.y+=36;
    frame.size.width-=CellEdgeInset;
    frame.size.height-=CellEdgeInset;
    cell.selectedBackgroundView.frame=frame;
    cell.selectedBackgroundView.layer.cornerRadius=10.f;
    cell.selectedBackgroundView.layer.masksToBounds=YES;
    //label
    UILabel * todayLabelL=[[UILabel alloc]init];
    UILabel * todayLabelR=[[UILabel alloc]init];
    [todayLabelL setTextAlignment:NSTextAlignmentRight];
    [todayLabelR setTextAlignment:NSTextAlignmentLeft];
    [todayLabelL setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [todayLabelR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    [todayLabelR setText:@" TODAY"];
    [todayLabelL setText:@"your bill"];
    [todayLabelR setTextColor:[UIColor whiteColor] ];
    [todayLabelL setTextColor:[UIColor whiteColor] ];
    [todayView addSubview:todayLabelR];
    [todayView addSubview:todayLabelL];
    [todayLabelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayView.mas_left).with.offset(31);
        make.top.equalTo(todayView.mas_top).with.offset(26);
    }];
    [todayLabelR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayLabelL.mas_right);
        make.top.equalTo(todayView.mas_top).with.offset(26);
    }];
    self.todaySumLabel=[[UILabel alloc]init];
    [self.todaySumLabel setTextColor:[UIColor whiteColor]];
    [self.todaySumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:48]];
    [self.todaySumLabel setTextAlignment:NSTextAlignmentCenter];
    [self.todaySumLabel setText:[NSString stringWithFormat:@"%+.2lf",[[OBBillManager sharedInstance] sumOfDay:[NSDate date]]]];
    [todayView addSubview:self.todaySumLabel];
    [self.todaySumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(todayView.mas_centerX);
        make.top.equalTo(todayLabelR.mas_bottom).with.offset(5);
    }];
    self.reloadIndicator= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.tableView addSubview:self.reloadIndicator];
    [self.reloadIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.bottom.equalTo(self.tableView.mas_top);
        make.height.equalTo(@(TableViewRefreshInset));
    }];
    self.tableView.contentInset=UIEdgeInsetsMake(TableViewRefreshInset, 0, 54, 0);
    [self.reloadIndicator setHidesWhenStopped:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.summaryArr.count-1) {
        UITableViewCell * cell=[[UITableViewCell alloc]init];
        [self setTodayCell:cell];
        return cell;
    }
    else{
        OBDaySummaryTableViewCell * cell=[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setWithDaySummary:self.summaryArr[indexPath.row]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row==self.summaryArr.count-1)?todayCellHeight:commonCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.summaryArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BillDetailViewController * vc=[[BillDetailViewController alloc]initWithBills:[[OBBillManager sharedInstance] billsSameDayAsDate:self.summaryArr[indexPath.row].date]];
    vc.date=self.summaryArr[indexPath.row].date;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - refresh&fetch more

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0 && !self.fetchStopFlag) {
        [self.reloadIndicator startAnimating];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.tableView.contentOffset.y<=0 && !decelerate && !self.fetchStopFlag) {
        [self.tableView setContentOffset:CGPointMake(0, -TableViewRefreshInset) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self insertCellAndBackToRightPosition];
            [self.reloadIndicator stopAnimating];
        });
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.tableView.contentOffset.y<=0 && !self.fetchStopFlag) {
        [self.tableView setContentOffset:CGPointMake(0, -TableViewRefreshInset) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self insertCellAndBackToRightPosition];
            [self.reloadIndicator stopAnimating];
        });
    }
}

-(void)insertCellAndBackToRightPosition{
    NSArray * tempArr=[[OBBillManager sharedInstance] fetchDaySummaryFromIndex:self.fetchIndex WithAmount:FetchEachTime];
    NSInteger count=tempArr.count;
    [self.summaryArr insertObjects:tempArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,count)]];
    self.fetchIndex+=count;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.fetchStopFlag=NO;
    if (count!=FetchEachTime) {
        self.fetchStopFlag=YES;
        self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 54, 0);
    }
}

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
