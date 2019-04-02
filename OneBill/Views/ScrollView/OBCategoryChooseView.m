//
//  OBCategoryChooseView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/28.
//  Copyright © 2018 ookkee. All rights reserved.
//

#define LightGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

#import "OBCategoryChooseView.h"
#import "OBCategoryChooseViewCell.h"
#import "OBCategoryManager.h"

@interface OBCategoryChooseView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton * bottomButton;
@property (nonatomic, strong) UIView * actualView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * categoryArr;
@property (nonatomic, strong) OBCategoryChooseViewCell * selectedCell;
@property (nonatomic, strong) UITextField * addingField;
@property BOOL isAdding;
@end

@implementation OBCategoryChooseView

CGFloat foldPositionY;

- (instancetype)initWithCategories:(NSArray<NSString *>*)categoryArr
{
    self = [super init];
    if (self) {
        self.isAdding=NO;
        self.categoryArr=categoryArr.mutableCopy;
        foldPositionY=308;
        self.dimView=[[UIView alloc]init];
        self.dimView.backgroundColor=[UIColor blackColor];
        self.dimView.alpha=0.3;
        [self addSubview:self.dimView];
        [self.dimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).with.offset(-foldPositionY+10);
        }];
        self.actualView=[[UIView alloc]init];
        self.actualView.backgroundColor=[UIColor whiteColor];
        self.actualView.layer.cornerRadius=10.f;
        [self addSubview:self.actualView];
        [self.actualView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_bottom).with.offset(-foldPositionY);
        }];
        self.bottomButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.bottomButton setImage:[UIImage imageNamed:@"categoryAddButton"] forState:UIControlStateNormal];
        [self.bottomButton setImageEdgeInsets:UIEdgeInsetsMake(14, ([UIScreen mainScreen].bounds.size.width-16)/2, 14, ([UIScreen mainScreen].bounds.size.width-16)/2)];
        [self.actualView addSubview:self.bottomButton];
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actualView.mas_left);
            make.right.equalTo(self.actualView.mas_right);
            make.bottom.equalTo(self.actualView.mas_bottom).with.offset(-14);
            make.height.equalTo(@(44));
        }];
        [self.bottomButton addTarget:self action:@selector(addCategory) forControlEvents:UIControlEventTouchUpInside];
        self.tableView=[[UITableView alloc]init];
        [self.actualView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.actualView.mas_top).with.offset(14);
            make.bottom.equalTo(self.bottomButton.mas_top).with.offset(-9);
            make.left.equalTo(self.actualView.mas_left);
            make.right.equalTo(self.actualView.mas_right);
        }];
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset=UIEdgeInsetsMake(-9, 0, 0, 0);
        self.tableView.rowHeight=60;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        [self.tableView registerClass:[OBCategoryChooseViewCell class] forCellReuseIdentifier:@"categoryCell"];
    }
    return self;
}

-(void)setAddingCell:(UITableViewCell *)cell{
    self.addingField=[[UITextField alloc]init];
    self.addingField.font=[UIFont fontWithName:@"HelveticaNeue" size:18];
    self.addingField.textColor=LightGrayColor;
    self.addingField.textAlignment=NSTextAlignmentCenter;
    self.addingField.autocorrectionType=UITextAutocorrectionTypeNo;
    self.addingField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    [cell.contentView addSubview:self.addingField];
    [self.addingField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).with.offset(20);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isAdding && indexPath.row>=self.categoryArr.count){//增加的输入栏
        UITableViewCell * cell=[[UITableViewCell alloc]init];
        [self setAddingCell:cell];
        [self.addingField becomeFirstResponder];
        return cell;
    }
    else{
        OBCategoryChooseViewCell * cell=[self.tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
        cell.label.text=self.categoryArr[indexPath.row];
        //确保复用时正确高亮选择的分类
        if (![cell.label.text isEqualToString:self.selectedCategory]) {
            [cell downplay];
        }
        else{
            [cell highlight];
        }
        if (indexPath.row==0) self.selectedCell=cell;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isAdding?self.categoryArr.count+1:self.categoryArr.count;
}


-(void)setSelectedCategory:(NSString *)selectedCategory{
    _selectedCategory=selectedCategory;
    NSInteger index=[self.categoryArr indexOfObject:selectedCategory];
    [self.selectedCell downplay];
    self.selectedCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self.selectedCell highlight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isAdding) {
        if (![self.categoryArr[indexPath.row] isEqualToString:self.selectedCategory]) {
            [(OBCategoryChooseViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.categoryArr indexOfObject:self.selectedCategory] inSection:0]] downplay];
            self.selectedCell=[tableView cellForRowAtIndexPath:indexPath];
            [self.selectedCell highlight];
            self.selectedCategory=self.selectedCell.label.text;
        }
    }
}

//bottomButtonAction
- (void)addCategory{
    //确认按钮随键盘移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:)                                           name:UIKeyboardWillChangeFrameNotification object:nil];
    self.isAdding=YES;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count inSection:0]] withRowAnimation:YES];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.categoryArr.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//弹出键盘时
-(void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGRect frame=self.frame;
    frame.origin.y=keyboardRect.origin.y-frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=frame;
    }];
}

//添加分类后进行的动作
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(self.isAdding){
        self.isAdding=NO;
        [self.addingField resignFirstResponder];
        self.addingField.enabled=NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        if(self.addingField.text.length){
            if (![[NSSet setWithArray:self.categoryArr] containsObject:self.addingField.text]) {//不重复则加入并保存
                [self.categoryArr addObject:self.addingField.text];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.categoryArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                [[OBCategoryManager sharedInstance].categoriesArr addObject:self.addingField.text];
                [[OBCategoryManager sharedInstance]writeToFile];
            }
            else{//否则提示
                MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
                hud.mode=MBProgressHUDModeText;
                hud.label.text=@"Category Already Existed";
                [hud hideAnimated:YES afterDelay:1.5];
            }
        }
        self.dimView.userInteractionEnabled=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.dimView.userInteractionEnabled=YES;
        });
        return NO;
    }
    return [super pointInside:point withEvent:event];
}
@end
