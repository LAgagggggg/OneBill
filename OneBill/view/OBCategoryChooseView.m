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
@property (strong,nonatomic)UIView * dimView;
@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSArray<NSString *> * categoryArr;
@end

@implementation OBCategoryChooseView

CGFloat foldPositionY;

- (instancetype)initWithCategories:(NSArray<NSString *>*)categoryArr
{
    self = [super init];
    if (self) {
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
    cell.label.text=self.categoryArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
