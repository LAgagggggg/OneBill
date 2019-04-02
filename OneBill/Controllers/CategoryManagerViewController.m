//
//  CategoryManagerViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import <objc/runtime.h>
#import "CategoryManagerViewController.h"
#import  "CategoryManagerCell.h"
#import  "OBCategoryManager.h"

#define grayWhiteColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIView * shadowView;
@property (strong, nonatomic) NSMutableIndexSet * selectedIndexSet;
@property (strong, nonatomic) NSMutableArray<NSString *> * categoryArr;
@property (strong, nonatomic) CategoryManagerCell * addCell;
@property (strong, nonatomic) UIButton * addButton;
@property (strong, nonatomic) UIBarButtonItem * deleteButton;
@property (strong, nonatomic) UIBarButtonItem * doneButton;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;
@property BOOL isAdding;
@property BOOL isMultiDeleting;

@end

static float animationDuration=0.3;

@implementation CategoryManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryArr=[OBCategoryManager sharedInstance].categoriesArr.mutableCopy;
    [self setUI];
    //添加cell随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.isAdding=NO;
    self.isMultiDeleting=NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self exchangeShadowMethod];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self exchangeShadowMethod];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isMultiDeleting) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
}

- (void)setUI {
    self.automaticallyAdjustsScrollViewInsets=NO;
    //设置导航栏返回按钮
    UIBarButtonItem * returnBarButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnButton"] style:UIBarButtonItemStylePlain target:self action:@selector(returnButtonClicked)];
    self.navigationItem.leftBarButtonItem=returnBarButton;
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    self.navigationItem.title=@"Categories";
    self.view.backgroundColor=grayWhiteColor;
    self.deleteButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"categoryDeleteButton"] style:UIBarButtonItemStylePlain target:self action:@selector(beginMultiDelete)];
    self.doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneMultiDelete)];
    self.navigationItem.rightBarButtonItem=self.deleteButton;
    //顶部阴影
    CGRect rectStatus=[[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav=self.navigationController.navigationBar.frame;
    self.shadowView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, rectNav.size.width, rectStatus.size.height+rectNav.size.height)];
    [self.view addSubview:self.shadowView];
    self.shadowView.backgroundColor=self.view.backgroundColor;
    self.shadowView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.shadowView.layer.shadowOffset=CGSizeMake(0, 3);
    self.shadowView.layer.shadowOpacity=0.1;
    self.shadowView.layer.shadowRadius=12;
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.shadowView.bounds cornerRadius:10.f];
    self.shadowView.layer.shadowPath=shadowPath.CGPath;
    //set tableView
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.top.equalTo(self.shadowView.mas_bottom);
        make.left.equalTo(self.view.mas_left).with.offset(37);
        make.right.equalTo(self.view.mas_right).with.offset(-37);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=56;
    self.tableView.contentInset=UIEdgeInsetsMake(16, 0, 30, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.allowsSelection=YES;
//    self.tableView.editing=YES;
    [self.tableView registerClass:[CategoryManagerCell class] forCellReuseIdentifier:@"categoryCell"];
//    用于resign first responder
    self.tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAnyResponder)];
    self.tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view bringSubviewToFront:self.shadowView];
}

- (void)returnButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSIndexSet *)selectedIndexSet {
    if (!_selectedIndexSet) {
        _selectedIndexSet=[[NSMutableIndexSet alloc] init];
    }
    return _selectedIndexSet;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryManagerCell * cell=nil;
    if (indexPath.row==self.categoryArr.count) {
        cell=[[CategoryManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [self setBottomCell:cell];
        self.addCell=cell;
        cell.hidden=self.isMultiDeleting;
    } else {
        cell=[tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
        [cell setWithCategory:self.categoryArr[indexPath.row]];
    }
    return cell;
}

//something about multiple delete
- (void)tableView:(UITableView *)tableView willDisplayCell:(CategoryManagerCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<self.categoryArr.count) {
        if (self.isMultiDeleting) {
            [cell beginMultiDelete];
        } else {
            [cell endMultiDelete];
        }
    }
    //拖拽相关
    cell.shouldIndentWhileEditing=NO;
}

#pragma mark - add&edit category

- (void)setBottomCell:(CategoryManagerCell *)cell {
    [cell.editButton setHidden:YES];
    [cell.categoryTextField setHidden:YES];
    cell.categoryTextField.userInteractionEnabled=YES;
    cell.categoryTextField.delegate=self;
    self.addButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.addButton setTintColor:textGrayColor];
    [self.addButton setImage:[UIImage imageNamed:@"categoryAddButton_dim"] forState:UIControlStateNormal];
    [cell.contentView addSubview:self.addButton];
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker * make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.right.equalTo(cell.contentView.mas_right);
        make.top.equalTo(cell.contentView.mas_top);
        make.bottom.equalTo(cell.contentView.mas_bottom);
    }];
    [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addButtonClicked:(UIButton *)sender {
    self.isAdding=YES;
    sender.hidden=YES;
    self.addCell.categoryTextField.hidden=NO;
    [self.addCell.categoryTextField becomeFirstResponder];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary * userInfo=[notification userInfo];
    NSValue * value=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[value CGRectValue];
    UIEdgeInsets inset=self.tableView.contentInset;
    inset.bottom=[UIScreen mainScreen].bounds.size.height-keyboardRect.origin.y+25;
    self.tableView.contentInset=inset;
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"

//action of tap gesture for self.view
- (void)resignAnyResponder {
    //resign current first responder
    UIWindow * keyWindow=[[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder=[keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder.superview.superview isKindOfClass:[CategoryManagerCell class]] && !self.isAdding) {
        firstResponder.userInteractionEnabled=NO;
    }
    [firstResponder resignFirstResponder];
}

//only for adding
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length) {
        if (![self.categoryArr containsObject:textField.text]) {
            [self.categoryArr addObject:textField.text];
            [[OBCategoryManager sharedInstance].categoriesArr addObject:textField.text];
            [[OBCategoryManager sharedInstance] writeToFile];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            MBProgressHUD * hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"Category Already Existed";
            [hud hideAnimated:YES afterDelay:1];
        }
    }
    self.isAdding=NO;
    self.addButton.hidden=NO;
    self.addCell.categoryTextField.text=@"";
    self.addCell.categoryTextField.hidden=YES;
}

#pragma mark - multi-delete

- (void)beginMultiDelete {
    self.isMultiDeleting=YES;
//    self.tableView.editing=NO;
    self.tapGestureRecognizer.enabled=NO;
    self.navigationItem.rightBarButtonItem=self.doneButton;
    [UIView animateWithDuration:animationDuration animations:^{
        self.navigationItem.title=@"Multiple Delete";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
        self.shadowView.backgroundColor=DarkBlueColor;
        self.shadowView.layer.masksToBounds=YES;
        self.view.backgroundColor=DarkBlueColor;
        self.addCell.alpha=0;
    }];
    [self.tableView reloadData];
}

- (void)doneMultiDelete {
    self.isMultiDeleting=NO;
//    self.tableView.editing=YES;
    self.tapGestureRecognizer.enabled=YES;
    if (self.selectedIndexSet.count) {
        [[OBCategoryManager sharedInstance].categoriesArr removeObjectsAtIndexes:self.selectedIndexSet];
        self.categoryArr=[OBCategoryManager sharedInstance].categoriesArr.mutableCopy;
        [[OBCategoryManager sharedInstance] writeToFile];
        [self.selectedIndexSet removeAllIndexes];
    }
    self.navigationItem.rightBarButtonItem=self.deleteButton;
    [UIView animateWithDuration:animationDuration animations:^{
        self.navigationItem.title=@"Categories";
        self.navigationItem.leftBarButtonItem.tintColor=[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]}];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        self.shadowView.backgroundColor=grayWhiteColor;
        self.shadowView.layer.masksToBounds=NO;
        self.view.backgroundColor=grayWhiteColor;
        self.addCell.alpha=1;
    }];
    [self.tableView reloadData];

////    [self.tableView setValue:nil forKeyPath:@"_shadowUpdatesController"];
//    [self.tableView setValue:[UIColor clearColor] forKeyPath:@"_separatorTopShadowColor"];
//    [self.tableView setValue:[UIColor clearColor] forKeyPath:@"_separatorBottomShadowColor"];
//    unsigned int count=0;
////    Class class=NSClassFromString(@"_UITableViewShadowUpdatesController");
//    Ivar * ivars=class_copyIvarList([self.tableView class], &count);
////    NSLog(@"%@",NSStringFromClass(self.tableView.superclass));
//    for (int i=0; i<count; i++) {
//        Ivar var=ivars[i];
//        const char * varName=ivar_getName(var);
//        const char * varType=ivar_getTypeEncoding(var);
//        NSLog(@"%s--%s",varName,varType);
//    }
//    free(ivars);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isMultiDeleting) {
        CategoryManagerCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.isSelected) {
            [cell multiDeleteBeDeselected];
            [self.selectedIndexSet removeIndex:indexPath.row];
        } else {
            [cell multiDeleteBeSelected];
            [self.selectedIndexSet addIndex:indexPath.row];
        }
    }
}

#pragma mark - drag to sort

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiDeleting) {//防止拖动最后的添加cell
        return indexPath.row!=self.categoryArr.count;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.categoryArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [[OBCategoryManager sharedInstance].categoriesArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        [[OBCategoryManager sharedInstance] writeToFile];
    });
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

//- (void)exchangeShadowMethod{
//    Class class = objc_getClass("UIShadowView");
////    unsigned int count=0;
////    Method * methods = class_copyMethodList(class, &count);
////    for (int i=0; i<count; i++) {
////        Method method=methods[i];
////        const char * methodName=sel_getName(method_getName(method));
////        const char * methodType=method_getTypeEncoding(method);
////        NSLog(@"%s--%s",methodName,methodType);
////    }
//    SEL originalSelector = @selector(setShadowImage:forEdge:inside:);
//    SEL mySelector = @selector(fakeMethodForShadow);
//    if (class_respondsToSelector(class, originalSelector)) {
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method myMethod = class_getInstanceMethod([self class], mySelector);
//        IMP originalImp = method_getImplementation(originalMethod);
//        IMP myImp = method_getImplementation(myMethod);
//        class_replaceMethod([self class], mySelector, originalImp, method_getTypeEncoding(myMethod));
//        class_replaceMethod(class, originalSelector,myImp, method_getTypeEncoding(originalMethod));
//    }
//}
//
//- (void)fakeMethodForShadow
//{
//
//}


@end
