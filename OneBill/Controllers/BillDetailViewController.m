//
//  BillDetailViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <Masonry.h>
#import "BillDetailViewController.h"
#import "NewOrEditBillViewController.h"
#import "OBDaySummaryCardView.h"
#import "OBDetailCardCell.h"
#import "OBCategoryChooseView.h"
#import "CategoryManager.h"
#import "OBDetailTableView.h"


#define CellEdgeInset 8

@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic)NSMutableArray<OBBill *>* billsArr;
@property (strong,nonatomic)OBDetailTableView * tableView;
@property (strong,nonatomic)OBCategoryChooseView * categoryChooseView;
@property (strong,nonatomic)OBBill * editingBill;
@property (strong,nonatomic)NSString * editingBillOldCategory;
@property (strong,nonatomic)NSIndexPath * editingIndexPath;

@end

@implementation BillDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.summaryCardView setDate:self.date Money:[[OBBillManager sharedInstance]sumOfDay:self.date]];
    [self addObserver:self forKeyPath:@"categoryChooseView.selectedCategory" options:NSKeyValueObservingOptionNew context:nil];
    //上划转场动画
    self.interactivePop=[OBInteractiveTransition interactiveTransitionWithTransitionType:OBInteractiveTransitionTypePop GestureDirection:OBInteractiveTransitionGestureDirectionDown];
    self.interactivePop.vc=self;
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]init];
    [self.summaryCardView addGestureRecognizer:pan];
    [self.interactivePop setPanGestureRecognizer:pan];
    //边缘右滑
    UIScreenEdgePanGestureRecognizer * edgePan=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanChanged:)];
    edgePan.edges=UIRectEdgeLeft;
    [self.tableView addGestureRecognizer:edgePan];
    [self.interactivePop setPanGestureRecognizer:edgePan];
//    移动到底部
//    if (self.billsArr.count) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.billsArr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
}

-(void)viewWillAppear:(BOOL)animated{//更新今日花销
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double sumOfDay=[[OBBillManager sharedInstance]sumOfDay:self.date];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.summaryCardView setDate:self.date Money:sumOfDay];
        });
    });
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"categoryChooseView.selectedCategory"];
}

-(void)setUI{
    self.title=@"Bill detail";
    self.automaticallyAdjustsScrollViewInsets=NO;
    //导航栏搜索按钮
//    UIBarButtonItem * searchBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barSearchBtn"] style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.rightBarButtonItem=searchBtn;
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnBtn"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    self.navigationItem.leftBarButtonItem=returnBarBtn;
//    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    //顶部遮盖
    UIView * shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,100)];
    [self.view addSubview:shadowView];
    shadowView.backgroundColor=self.view.backgroundColor;
    self.summaryCardView=[[OBDaySummaryCardView alloc]init];
    [self.view addSubview:self.summaryCardView];
    [self.summaryCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(30);
        make.right.equalTo(self.view.mas_right).with.offset(-30);
        make.top.equalTo(self.view.mas_top).with.offset(93);
        make.height.equalTo(@(58+22));
    }];
    self.tableView=[[OBDetailTableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.summaryCardView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryCardView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.layer.masksToBounds=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset=UIEdgeInsetsMake(8, 0, 20, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.estimatedRowHeight=117;
    [self.tableView registerClass:[OBDetailCardCell class] forCellReuseIdentifier:reuseIdentifier];
    self.categoryChooseView=[[OBCategoryChooseView alloc]initWithCategories:[CategoryManager sharedInstance].categoriesArr];
    [self.view addSubview:self.categoryChooseView];
    self.categoryChooseView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(resignCategoryChooseView)];
    [self.categoryChooseView.dimView addGestureRecognizer:tap];
    [self.view bringSubviewToFront:shadowView];
    [self.view bringSubviewToFront:self.summaryCardView];
    [self.view bringSubviewToFront:self.categoryChooseView];
}

- (instancetype)initWithBills:(NSArray<OBBill *>*)bills
{
    self = [super init];
    if (self) {
        self.billsArr=bills.mutableCopy;
    }
    return self;
}

#pragma mark CategoryEdit
-(void)categoryBtnClicked:(id)sender{
    UIButton * button=(UIButton *)sender;
    self.editingIndexPath=[self.tableView indexPathForCell:(UITableViewCell *)button.superview.superview];
    self.editingBill=self.billsArr[self.editingIndexPath.row];
    self.editingBillOldCategory=self.editingBill.category;
    self.categoryChooseView.selectedCategory=button.titleLabel.text;
    [self showCategoryChooseView];
}

-(void)resignCategoryChooseView{
    if (![self.categoryChooseView.selectedCategory isEqualToString:self.editingBillOldCategory]) {
        [[OBBillManager sharedInstance] editBillOfDate:self.editingBill.date Value:self.editingBill.value withBill:self.editingBill];
    }
    CGRect frame=self.categoryChooseView.frame;
    frame.origin.y=[UIScreen mainScreen].bounds.size.height;
    self.categoryChooseView.dimView.alpha=0.3;
    [UIView animateWithDuration:0.3 animations:^{
        self.categoryChooseView.dimView.alpha=0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
           self.categoryChooseView.frame=frame;
        }];
    }];
}

-(void)showCategoryChooseView{
    CGRect frame=self.categoryChooseView.frame;
    frame.origin.y=0;
    self.categoryChooseView.dimView.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.categoryChooseView.frame=frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.categoryChooseView.dimView.alpha=0.3;
        }];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"categoryChooseView.selectedCategory"] && object==self) {
        //更改cell的category
        self.editingBill.category=self.categoryChooseView.selectedCategory;
        [self.tableView reloadRowsAtIndexPaths:@[self.editingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OBDetailCardCell * cell=[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OBDetailCardCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setCellWithBill:self.billsArr[indexPath.row] andStylePreference:OBTimeLibelTimeOnly];
    [cell.categoryBtn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - edit&delete

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewOrEditBillViewController * vc=[[NewOrEditBillViewController alloc]init];
    [vc editModeWithBill:self.billsArr[indexPath.row]];
    vc.editCompletedHandler = ^{
        [self updateEditedCell];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateEditedCell{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        self.billsArr=[[OBBillManager sharedInstance] billsSameDayAsDate:self.date].mutableCopy;
            dispatch_sync(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
        });
    });
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[OBBillManager sharedInstance] removeBill:self.billsArr[indexPath.row]];
        [[OBBillManager sharedInstance] updateSumOfDay:self.billsArr[indexPath.row].date];
        if(@available(iOS 11,*)){
        }
        else{
            for (int i = (int)indexPath.row; i<self.billsArr.count; i++) {
                OBDetailCardCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.frameSolidFlag=0;
                CGRect newFrame=cell.solidFrame;
                newFrame.origin.y -= 117;
                cell.solidFrame=newFrame;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.summaryCardView setDate:self.billsArr[indexPath.row].date Money:[[OBBillManager sharedInstance] sumOfDay:self.billsArr[indexPath.row].date]];
            [self.billsArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        });
    });
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 11,*)) {//only set deleteBtn for above iOS11 here, under iOS11 will be set in cell
        for (UIView *subview in tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
            {
                subview.backgroundColor=[UIColor clearColor];
                subview.layer.cornerRadius=10.f;
                subview.layer.masksToBounds=YES;
                UIView * deleteBtn=subview.subviews[0];
                deleteBtn.layer.cornerRadius=10.f;
                deleteBtn.layer.masksToBounds=YES;
            }
        }
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

#pragma mark - event response

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edgePanChanged:(UIScreenEdgePanGestureRecognizer *)edgePan{
    //统一边缘滑动手势和顶部卡片下滑手势
    CGPoint point=[edgePan translationInView:edgePan.view];
    point.y=point.x*1.2;
    [edgePan setTranslation:point inView:edgePan.view];
}

@end
