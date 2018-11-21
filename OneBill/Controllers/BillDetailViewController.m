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
#import "OBCategoryManager.h"
#import "OBDetailTableView.h"


#define CellEdgeInset 8

@interface BillDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray<OBBill *>* billsArr;
@property (nonatomic, strong) OBDetailTableView * tableView;
@property (nonatomic, strong) OBCategoryChooseView * categoryChooseView;
@property (nonatomic, strong) OBBill * editingBill;
@property (nonatomic, strong) NSString * editingBillOldCategory;
@property (nonatomic, strong) NSIndexPath * editingIndexPath;
@property (nonatomic, strong) UIView *  billEmptyView;

@end

@implementation BillDetailViewController
static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithBills:(NSArray<OBBill *>*)bills
{
    self = [super init];
    if (self) {
        self.billsArr=bills.mutableCopy;
    }
    return self;
}

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
        self.billsArr=[[OBBillManager sharedInstance] billsSameDayAsDate:self.date].mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.summaryCardView setDate:self.date Money:sumOfDay];
            [self.tableView reloadData];
            //没有账单则显示默认图
            if (self.billsArr.count==0) {
                self.billEmptyView.alpha=1;
            } else{
                self.billEmptyView.alpha=0;
            }
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
//    UIBarButtonItem * searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barSearchButton"] style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.rightBarButtonItem=searchButton;
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnButton"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonClicked)];
    self.navigationItem.leftBarButtonItem=returnBarButton;
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
    self.categoryChooseView=[[OBCategoryChooseView alloc]initWithCategories:[OBCategoryManager sharedInstance].categoriesArr];
    [self.view addSubview:self.categoryChooseView];
    self.categoryChooseView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(resignCategoryChooseView)];
    [self.categoryChooseView.dimView addGestureRecognizer:tap];
    [self.view bringSubviewToFront:shadowView];
    [self.view bringSubviewToFront:self.summaryCardView];
    [self.view bringSubviewToFront:self.categoryChooseView];
    //默认图
    self.billEmptyView=({
        UIView * billEmptyView=[[UIView alloc] init];
        [self.view addSubview:billEmptyView];
        [billEmptyView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.left.equalTo(self.view.mas_left).with.offset(30);
            make.right.equalTo(self.view.mas_right).with.offset(-30);
            make.top.equalTo(self.summaryCardView.mas_bottom).with.offset(67);
            make.height.equalTo(billEmptyView.mas_width).multipliedBy(335/316.0);
        }];
        billEmptyView.layer.contents=(__bridge id)[UIImage imageNamed:@"emptyDefaultImage"].CGImage;
        billEmptyView.layer.contentsGravity=kCAGravityResizeAspect;
        UIButton * addBillButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [billEmptyView addSubview:addBillButton];
        [addBillButton mas_makeConstraints:^(MASConstraintMaker * make) {
            make.width.mas_equalTo(163);
            make.height.mas_equalTo(42);
            make.centerX.equalTo(billEmptyView.mas_centerX);
            make.bottom.equalTo(billEmptyView.mas_bottom).with.offset(-67*[UIScreen mainScreen].bounds.size.width/375);
        }];
        addBillButton.backgroundColor=OB_DarkBlueColor;
//        addBillButton.alpha=0.8;
        addBillButton.layer.cornerRadius=10.f;
        [addBillButton setTitle:@"Add one Bill" forState:UIControlStateNormal];
        addBillButton.tintColor=[UIColor whiteColor];
        [addBillButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        billEmptyView;
    });
}

#pragma mark CategoryEdit
-(void)categoryButtonClicked:(id)sender{
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
    [cell.categoryButton addTarget:self action:@selector(categoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    NewOrEditBillViewController * addVC=[[NewOrEditBillViewController alloc]init];
    addVC.pushAnimationStartPoint=[self.tableView convertPoint:[self.tableView cellForRowAtIndexPath:indexPath].center toView:self.view.window];
    [addVC editModeWithBill:self.billsArr[indexPath.row]];
    addVC.editCompletedHandler = ^{
        [self updateEditedCell];
    };
    [self.navigationController pushViewController:addVC animated:YES];
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
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.billsArr.count==0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.billEmptyView.alpha=1;
                }];
            }
        });
    });
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 11,*)) {//only set deleteButton for above iOS11 here, under iOS11 will be set in cell
        for (UIView *subview in tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
            {
                subview.backgroundColor=[UIColor clearColor];
                subview.layer.cornerRadius=10.f;
                subview.layer.masksToBounds=YES;
                UIView * deleteButton=subview.subviews[0];
                deleteButton.layer.cornerRadius=10.f;
                deleteButton.layer.masksToBounds=YES;
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

- (void)addButtonClicked:(UIButton *)button{
    NewOrEditBillViewController * addVC=[[NewOrEditBillViewController alloc]init];
    addVC.pushAnimationStartPoint=[self.billEmptyView convertPoint:button.center toView:self.view.window];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)returnButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)edgePanChanged:(UIScreenEdgePanGestureRecognizer *)edgePan{
    //统一边缘滑动手势和顶部卡片下滑手势
    CGPoint point=[edgePan translationInView:edgePan.view];
    point.y=point.x*1.2;
    [edgePan setTranslation:point inView:edgePan.view];
}

@end
