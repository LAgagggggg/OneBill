//
//  CheckBillsViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/26.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CheckBillsViewController.h"
#import "CategoryManagerViewController.h"
#import  "OBCategoryManager.h"
#import  "OBBillManager.h"
#import  "OBDetailCardCell.h"
#import  "OBCategoryScrollView.h"
#import "PopUpDateSelectView.h"

#define CellEdgeInset 8

@interface CheckBillsViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,PopUpDateSelectViewDelegate>

@property (nonatomic, strong) NSDate * showingDate;

@property (nonatomic, strong) NSMutableArray<OBBill *>* billsArr;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) OBCategoryScrollView * categoryScrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSString * currentCategory;
@property (nonatomic, strong) UITapGestureRecognizer * textFieldResignTap;
@property (nonatomic, strong) PopUpDateSelectView * dateSelectView;
@property BOOL categoriesEditedFlag;

@end

@implementation CheckBillsViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self addObserver:self forKeyPath:@"categoryScrollView.currentCategory" options:NSKeyValueObservingOptionNew context:nil];
    self.categoriesEditedFlag=NO;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.categoriesEditedFlag) {
        [self setCategoryView];
        self.categoriesEditedFlag=NO;
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"categoryScrollView.currentCategory"];
}

-(void)setUI{
    self.title=@"Bills";
    self.automaticallyAdjustsScrollViewInsets=NO;
    //导航栏右侧按钮
    UIBarButtonItem * calendarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkBarCalendarButton"] style:UIBarButtonItemStylePlain target:self action:@selector(calendarButtonClicked)];
    UIBarButtonItem * moreButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barMoreButton"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonClicked)];
    self.navigationItem.rightBarButtonItems=@[moreButton,calendarButton];
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnButton"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonClicked)];
    self.navigationItem.leftBarButtonItem=returnBarButton;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    //顶部选择category
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,OB_TopHeight+10+88)];
    [self.view addSubview:self.topView];
    self.topView.backgroundColor=self.view.backgroundColor;
    self.topView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0, 3);
    self.topView.layer.shadowOpacity = 0.1;
    self.topView.layer.shadowRadius = 12;
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.topView.bounds cornerRadius:10.f];
    self.topView.layer.shadowPath=shadowPath.CGPath;
    [self setCategoryView];
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.topView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(8, 0, 20, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[OBDetailCardCell class] forCellReuseIdentifier:reuseIdentifier];
    //用于注销firstResponder
    self.textFieldResignTap=[[UITapGestureRecognizer alloc]init];
    [self.view addGestureRecognizer:self.textFieldResignTap];
    self.dateSelectView=[[PopUpDateSelectView alloc]initWithView:self.view];
    [self.view addSubview:self.dateSelectView];
    self.dateSelectView.delegate=self;
}

- (void)setCategoryView{//in order to refresh the category scrollView after categories being edited
    if (self.categoryScrollView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.categoryScrollView.alpha=0;
        } completion:^(BOOL finished) {
            [self.categoryScrollView removeFromSuperview];
            self.categoryScrollView=[[OBCategoryScrollView alloc]initWithCategorys:[OBCategoryManager sharedInstance].categoriesArr];
            self.categoryScrollView.alwaysShowSum=YES;
            [self.topView addSubview:self.categoryScrollView];
            [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).with.offset(OB_TopHeight+10);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.height.equalTo(@(88));
            }];
            [UIView animateWithDuration:0.3 animations:^{
                self.categoryScrollView.alpha=1;
            }];
        }];
    }
    else{
        self.categoryScrollView=[[OBCategoryScrollView alloc]initWithCategorys:[OBCategoryManager sharedInstance].categoriesArr];
        self.categoryScrollView.alwaysShowSum=YES;
        [self.topView addSubview:self.categoryScrollView];
        [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(OB_TopHeight+10);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@(88));
        }];
    }
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _showingDate=date;
        self.currentCategory=[OBCategoryManager sharedInstance].categoriesArr[0];
        self.billsArr=[[OBBillManager sharedInstance]billsSameMonthAsDate:_showingDate ofCategory:self.currentCategory].mutableCopy;
    }
    return self;
}

#pragma mark - UITableViewDelegate

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
        self.billsArr=[[OBBillManager sharedInstance]billsSameMonthAsDate:self.showingDate ofCategory:self.currentCategory].mutableCopy;
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

#pragma mark - popUpDateSelectView delegate

-(void)dateSelectView:(PopUpDateSelectView *)dateSelectView didSelectDate:(NSDate *)date{
    self.showingDate=date;
    self.billsArr=[[OBBillManager sharedInstance]billsSameMonthAsDate:self.showingDate ofCategory:self.currentCategory].mutableCopy;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self.tableView reloadData];
    self.categoryScrollView.dateOfSum=date;
}

#pragma mark - event response

- (void)returnButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonClicked{
    [[OBCategoryManager sharedInstance] registerWriteToFileCallBack:^{
        self.categoriesEditedFlag=YES;
    }];
    CategoryManagerViewController * vc=[[CategoryManagerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)calendarButtonClicked{
    [self.dateSelectView popUp];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self.categoryScrollView.addTextField isFirstResponder]) {
        [self.categoryScrollView.addTextField resignFirstResponder];
    }
    return YES;
}

@end
