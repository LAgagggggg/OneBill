//
//  OBCategoryChooseView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/28.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBCategoryChooseView.h"
#import "OBCategoryChooseViewCell.h"
#import <masonry.h>

@interface OBCategoryChooseView()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)UIButton * bottomBtn;
@property (strong,nonatomic)UIView * actualView;
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSArray<NSString *> * categoryArr;
@property (strong,nonatomic)OBCategoryChooseViewCell * selectedCell;
@property BOOL isAdding;
@end

@implementation OBCategoryChooseView

CGFloat foldPositionY;

- (instancetype)initWithCategories:(NSArray<NSString *>*)categoryArr
{
    self = [super init];
    if (self) {
        self.isAdding=NO;
        self.categoryArr=categoryArr;
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
        self.bottomBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.bottomBtn setImage:[UIImage imageNamed:@"categoryAddBtn"] forState:UIControlStateNormal];
        [self.bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(14, ([UIScreen mainScreen].bounds.size.width-16)/2, 14, ([UIScreen mainScreen].bounds.size.width-16)/2)];
        [self.actualView addSubview:self.bottomBtn];
        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actualView.mas_left);
            make.right.equalTo(self.actualView.mas_right);
            make.bottom.equalTo(self.actualView.mas_bottom).with.offset(-14);
            make.height.equalTo(@(44));
        }];
        [self.bottomBtn addTarget:self action:@selector(addCategory) forControlEvents:UIControlEventTouchUpInside];
        self.tableView=[[UITableView alloc]init];
        [self.actualView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.actualView.mas_top).with.offset(14);
            make.bottom.equalTo(self.bottomBtn.mas_top).with.offset(-9);
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OBCategoryChooseViewCell * cell=[self.tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    if (indexPath.row==0) self.selectedCell=cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(OBCategoryChooseViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.label.text=self.categoryArr[indexPath.row];
    //确保复用时正确高亮选择的分类
    if (![cell.label.text isEqualToString:self.selectedCategory]) {
        [cell downplay];
    }
    else{
        [cell highlight];
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
    if (![self.categoryArr[indexPath.row] isEqualToString:self.selectedCategory]) {
        [(OBCategoryChooseViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.categoryArr indexOfObject:self.selectedCategory] inSection:0]] downplay];
        self.selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        [self.selectedCell highlight];
        self.selectedCategory=self.selectedCell.label.text;
    }
}

//bottomBtnAction
- (void)addCategory{
    self.isAdding=YES;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.categoryArr.count inSection:0]] withRowAnimation:YES];
}
@end
