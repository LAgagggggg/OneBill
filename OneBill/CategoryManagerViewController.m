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
#import <MBProgressHUD.h>
#define grayWhiteColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)UIView * shadowView;
@property (strong,nonatomic)NSMutableArray<NSString *>* categoryArr;
@property (strong,nonatomic)CategoryManagerCell * addCell;
@property (strong,nonatomic)UIButton * addBtn;
@property (strong,nonatomic)UIBarButtonItem * deleteBtn;
@property (strong,nonatomic)UIBarButtonItem * doneBtn;
@property BOOL isAdding;
@property BOOL isMultiDeleting;
@end


static float animationDuration=0.3;
@implementation CategoryManagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryArr=[CategoryManager sharedInstance].categoriesArr.mutableCopy;
    [self setUI];
    //添加cell随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:)                                           name:UIKeyboardWillChangeFrameNotification object:nil];
    self.isAdding=NO;
    self.isMultiDeleting=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
}

- (void)setUI{
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"returnBtn"]  style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    self.navigationItem.leftBarButtonItem=returnBarBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.navigationItem.title=@"Categories";
    self.view.backgroundColor=grayWhiteColor;
    self.deleteBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"categoryDeleteBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(beginMultiDelete)];
    self.doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneMultiDelete)];
    self.navigationItem.rightBarButtonItem = self.deleteBtn;
    self.tableView.allowsMultipleSelection=YES;
    //顶部阴影
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    self.shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, rectNav.size.width, rectStatus.size.height+rectNav.size.height)];
    [self.view addSubview:self.shadowView];
    self.shadowView.backgroundColor=self.view.backgroundColor;
    self.shadowView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    self.shadowView.layer.shadowOpacity = 0.1;
    self.shadowView.layer.shadowRadius = 12;
    //set tableView
    self.tableView=[[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shadowView.mas_bottom);
        make.left.equalTo(self.view.mas_left).with.offset(37);
        make.right.equalTo(self.view.mas_right).with.offset(-37);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=58;
    self.tableView.contentInset=UIEdgeInsetsMake(16, 0, 30, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[CategoryManagerCell class] forCellReuseIdentifier:@"categoryCell"];
    //用于resign first responder
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAnyResponder)];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    [self.view bringSubviewToFront:self.shadowView];
}

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryManagerCell *cell=nil;
    if(indexPath.row==self.categoryArr.count){
        cell=[[CategoryManagerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [self setBottomCell:cell];
        self.addCell=cell;
        cell.hidden= self.isMultiDeleting?YES:NO;
    }
    else{
         cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
        [cell setWithCategory:self.categoryArr[indexPath.row]];
    }
    return cell;
}

//something about multiple delete
- (void)tableView:(UITableView *)tableView willDisplayCell:(CategoryManagerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.categoryArr.count) {
        if (self.isMultiDeleting) {
            [cell beginMultiDelete];
        }
        else{
            [cell endMultiDelete];
        }
    }
}

- (void)setBottomCell:(CategoryManagerCell *)cell{
    [cell.editBtn setHidden:YES];
    [cell.categoryTextField setHidden:YES];
    cell.categoryTextField.userInteractionEnabled=YES;
    cell.categoryTextField.delegate=self;
    self.addBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.addBtn setTintColor:textGrayColor];
    [self.addBtn setImage:[UIImage imageNamed:@"categoryAddBtn_dim"] forState:UIControlStateNormal];
    [cell.contentView addSubview:self.addBtn];
    [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
        make.top.equalTo(cell.contentView.mas_top);
        make.bottom.equalTo(cell.contentView.mas_bottom);
    }];
    [self.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.categoryArr.count) {//最后一行
        return NO;
    }
    for (UIView *subview in tableView.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
        {
            subview.backgroundColor=[UIColor clearColor];
            subview.subviews[0].layer.cornerRadius=10.f;
            subview.subviews[0].layer.masksToBounds=YES;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CategoryManager sharedInstance].categoriesArr removeObjectAtIndex:indexPath.row];
    [[CategoryManager sharedInstance] writeToFile];
    [self.categoryArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}



#pragma mark - add&edit category
- (void)addBtnClicked:(UIButton *)sender{
    self.isAdding=YES;
    sender.hidden=YES;
    self.addCell.categoryTextField.hidden=NO;
    [self.addCell.categoryTextField becomeFirstResponder];
    
}

-(void)keyboardWillChange:(NSNotification *)notification{
    if (self.isAdding) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [value CGRectValue];
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.bottom=[UIScreen mainScreen].bounds.size.height - keyboardRect.origin.y+30;
        self.tableView.contentInset=inset;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.categoryArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//action of tap gesture for self.view
- (void)resignAnyResponder{
    //resign current first responder
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder.superview.superview isKindOfClass:[CategoryManagerCell class]] && !self.isAdding) {
        firstResponder.userInteractionEnabled=NO;
    }
    [firstResponder resignFirstResponder];
}

//only for adding
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.text.length ){
        if (![self.categoryArr containsObject:textField.text]) {
            [self.categoryArr addObject:textField.text];
            [[CategoryManager sharedInstance].categoriesArr addObject:textField.text];
            [[CategoryManager sharedInstance]writeToFile];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"Category Already Existed";
            [hud hideAnimated:YES afterDelay:1];
        }
    }
    self.isAdding=NO;
    self.addBtn.hidden=NO;
    self.addCell.categoryTextField.text=@"";
    self.addCell.categoryTextField.hidden=YES;
}

#pragma mark - multi-delete

- (void)beginMultiDelete{
    [UIView animateWithDuration:animationDuration animations:^{
        self.isMultiDeleting=YES;
        self.navigationItem.rightBarButtonItem=self.doneBtn;
        self.navigationItem.title=@"Multiple Delete";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
        self.shadowView.backgroundColor=DarkBlueColor;
        self.shadowView.layer.masksToBounds=YES;
        self.view.backgroundColor=DarkBlueColor;
        self.addCell.hidden=YES;
        [self.tableView reloadData];
    }];
}

-(void)doneMultiDelete{
    [UIView animateWithDuration:animationDuration animations:^{
        self.isMultiDeleting=NO;
        self.navigationItem.rightBarButtonItem=self.deleteBtn;
        self.navigationItem.title=@"Categoried";
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        self.shadowView.backgroundColor=grayWhiteColor;
        self.shadowView.layer.masksToBounds=NO;
        self.view.backgroundColor=grayWhiteColor;
        self.addCell.hidden=NO;
        [self.tableView reloadData];
    }];
}

@end
