//
//  NewBillViewController.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "NewBillViewController.h"
#import "view/CategoryView.h"
#import "model/CategoryManager.h"
#import <Masonry.h>

@interface NewBillViewController ()
@property (strong,nonatomic)UIScrollView * categoryScrollView;
@property (strong,nonatomic)CategoryManager * categoryManager;
@end

@implementation NewBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryManager=[CategoryManager sharedInstance];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setCatgoryScrollView];
    
}

- (void)setCatgoryScrollView{
    self.categoryScrollView=[[UIScrollView alloc]init];
    self.categoryScrollView.showsVerticalScrollIndicator=NO;
    self.categoryScrollView.showsHorizontalScrollIndicator=NO;
    self.categoryScrollView.alwaysBounceHorizontal=YES;
    self.categoryScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.categoryScrollView];
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(123);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(62));
    }];
    float needWidth=0;
    int i=0;
    NSMutableArray * cViewArr=[[NSMutableArray alloc]init];
    for (NSString * category in self.categoryManager.categoriesArr) {
        CategoryView * cView=[[CategoryView alloc]initWithCategory:category];
        [cView layoutIfNeeded];
        needWidth+=cView.frame.size.width;
        [self.categoryScrollView addSubview:cView];
        if (i!=0) {
            needWidth+=21;
            CategoryView * lastView=cViewArr.lastObject;
            [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.categoryScrollView.mas_top);
                make.left.equalTo(lastView.mas_right).with.offset(21);
            }];
        }
        else{
            needWidth+=30;
            [cView highlight];
            [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.categoryScrollView.mas_top);
                make.left.equalTo(self.categoryScrollView.mas_left).with.offset(30);
            }];
        }
        i++;
        [cViewArr addObject:cView];
    }
    self.categoryScrollView.contentSize=CGSizeMake(needWidth, 62);
    self.categoryScrollView.scrollEnabled=YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
