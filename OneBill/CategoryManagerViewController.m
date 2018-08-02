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

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray<NSString *>* categoryArr;
@property (strong,nonatomic)CategoryManagerCell * addCell;
@property (strong,nonatomic)UIButton * addBtn;
@property BOOL isAdding;
@end

@implementation CategoryManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryArr=[CategoryManager sharedInstance].categoriesArr.mutableCopy;
    [self setUI];
    //添加cell随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:)                                           name:UIKeyboardWillChangeFrameNotification object:nil];
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
    self.tableView.contentInset=UIEdgeInsetsMake(16, 0, 30, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView registerClass:[CategoryManagerCell class] forCellReuseIdentifier:@"categoryCell"];
    //用于resign first responder
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAnyResponder)];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    [self.view bringSubviewToFront:shadowView];
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
    }
    else{
         cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
        [cell setWithCategory:self.categoryArr[indexPath.row]];
    }
    return cell;
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

#pragma mark - add category
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

- (void)returnBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

//action of tap gesture for self.view
- (void)resignAnyResponder{
    //resign current first responder
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder.superview.superview isKindOfClass:[CategoryManagerCell class]]) {
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
            self.categoryArr=[CategoryManager sharedInstance].categoriesArr;
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

@end
