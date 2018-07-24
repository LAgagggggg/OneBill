//
//  BillDetailViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "BillDetailViewController.h"
#import "view/OBDaySummaryCardView.h"
#import "view/OBTableViewCardCell.h"
#import <masonry.h>

@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)NSMutableArray<OBBill *>* billsArr;
@property (strong,nonatomic)OBDaySummaryCardView * summaryCardView;
@property (strong,nonatomic)UITableView * tableView;
@property double todaySpend;
@end

@implementation BillDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.todaySpend=0;
    for (OBBill * bill in self.billsArr) {
        self.todaySpend-= bill.isOut?bill.value:-bill.value;
    }
    [self.summaryCardView setDate:self.date Money:self.todaySpend];
}

-(void)setUI{
    self.title=@"Bill detail";
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    self.summaryCardView=[[OBDaySummaryCardView alloc]init];
    [self.view addSubview:self.summaryCardView];
    [self.summaryCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.top.equalTo(self.view.mas_top).with.offset(93);
        make.height.equalTo(@(58));
    }];
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.summaryCardView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryCardView.mas_top);
        make.left.equalTo(self.view.mas_left).with.offset(30-8);
        make.right.equalTo(self.view.mas_right).with.offset(-30+8);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITextBorderStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(58+25+12, 0, 0, 0);
    [self.tableView registerClass:[OBTableViewCardCell class] forCellReuseIdentifier:reuseIdentifier];
//    self.tableView.ed
}

- (instancetype)initWithBills:(NSArray<OBBill *>*)bills
{
    self = [super init];
    if (self) {
        self.billsArr=bills.mutableCopy;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OBTableViewCardCell * cell=[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setCellWithBill:self.billsArr[indexPath.row]];
    return cell;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *subview in tableView.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
        {
            subview.backgroundColor=[UIColor blueColor];
            subview.subviews[0].layer.cornerRadius=10.f;
            subview.subviews[0].layer.masksToBounds=YES;
            CGRect frame=subview.subviews[0].frame;
            frame.size.width-=8;
            subview.subviews[0].frame=frame;
            
        }
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.billsArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UIView *subview in tableView.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")] )
        {
            float alphaSaver=subview.subviews[0].alpha;
            [UIView animateWithDuration:0.3 animations:^{
                subview.subviews[0].alpha=0;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    subview.subviews[0].alpha=alphaSaver;
                });
            }];
        }
    }
}


@end
