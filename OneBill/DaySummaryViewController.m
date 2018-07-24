//
//  DaySummaryViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/24.
//  Copyright © 2018 ookkee. All rights reserved.
//
#import <masonry.h>
#import "DaySummaryViewController.h"
#import "view/OBDaySummaryTableViewCell.h"

@interface DaySummaryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView * tableView;
@end

@implementation DaySummaryViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
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
        make.left.equalTo(self.view.mas_left).with.offset(30-8);
        make.right.equalTo(self.view.mas_right).with.offset(-30+8);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
//    self.tableView.contentInset=UIEdgeInsetsMake(58+25+12, 0, 0, 0);
    [self.tableView registerClass:[OBDaySummaryTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

@end
