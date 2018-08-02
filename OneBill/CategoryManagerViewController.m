//
//  CategoryManagerViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManagerViewController.h"
#import "view/CategoryManagerCell.h"
#import "model/CategoryManager.h"
#import <masonry.h>

@interface CategoryManagerViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray<NSString *>* categoryArr;
@end

@implementation CategoryManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryArr=[CategoryManager sharedInstance].categoriesArr.mutableCopy;
    [self setUI];
}

- (void)setUI{
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
    self.navigationItem.title=@"Categories";
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self.editButtonItem setImage:[UIImage imageNamed:@"categoryDeleteBtn"]];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    //set tableView
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shadowView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=58;
    self.tableView.contentInset=UIEdgeInsetsMake(16, 0, 0, 0);
    [self.tableView registerClass:[CategoryManagerCell class] forCellReuseIdentifier:@"categoryCell"];
    //用于resign first responder
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CategoryManagerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setWithCategory:self.categoryArr[indexPath.row]];
}

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //resign current first responder
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder.superview.superview isKindOfClass:[CategoryManagerCell class]]) {
        firstResponder.userInteractionEnabled=NO;
    }
    [firstResponder resignFirstResponder];
    return NO;
}

@end
