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

@interface DaySummaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray<OBDaySummary *> * summaryArr;
@property NSInteger fetchIndex;
@end

@implementation DaySummaryViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchIndex=0;
    [[OBBillManager sharedInstance]updateSumOfDay:[NSDate date]];
    self.summaryArr=[NSMutableArray arrayWithArray:[[OBBillManager sharedInstance] fetchDaySummaryFromIndex:self.fetchIndex WithAmount:10]];
    self.fetchIndex+=10;
    [self setUI];
}

-(void)setUI{
    self.title=@"Bills";
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).with.offset(30-CellEdgeInset);
        make.right.equalTo(self.view.mas_right).with.offset(-30+CellEdgeInset);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 54, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[OBDaySummaryTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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

- (void)setTodayCell:(UITableViewCell *)cell{
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.summaryArr.count-1) {
        return todayCellHeight;
    }
    else{
        return commonCellHeight;
    }
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

@end
