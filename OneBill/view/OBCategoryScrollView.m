//
//  OBCategoryScrollView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/20.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBCategoryScrollView.h"
#import <masonry.h>

@implementation OBCategoryScrollView

- (instancetype)initWithCategorys:(NSArray<NSString *>*)categoriesArr
{
    self = [super init];
    if (self) {
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.alwaysBounceHorizontal=YES;
        self.backgroundColor=[UIColor clearColor];
        float needWidth=0;
        int i=0;
        NSMutableArray * cViewArr=[[NSMutableArray alloc]init];
        for (NSString * category in categoriesArr) {
            CategoryView * cView=[[CategoryView alloc]initWithCategory:category];
            [cView layoutIfNeeded];
            needWidth+=cView.frame.size.width;
            [self addSubview:cView];
            [cView.button addTarget:self action:@selector(didClickOneView:) forControlEvents:UIControlEventTouchUpInside];
            if (i!=0) {
                needWidth+=21;
                CategoryView * lastView=cViewArr.lastObject;
                [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top);
                    make.left.equalTo(lastView.mas_right).with.offset(21);
                }];
            }
            else{
                needWidth+=30;
                [cView highlight];
                self.selectedView=cView;
                [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top);
                    make.left.equalTo(self.mas_left).with.offset(30);
                }];
            }
            i++;
            [cViewArr addObject:cView];
        }
        CategoryView * cView=[[CategoryView alloc]initWithCategory:@"···"];
        [self addSubview:cView];
        [cView layoutIfNeeded];
        needWidth+=21;
        needWidth+=cView.frame.size.width;
        CategoryView * lastView=cViewArr.lastObject;
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(lastView.mas_right).with.offset(21);
        }];
        self.contentSize=CGSizeMake(needWidth+30, 62);
        self.scrollEnabled=YES;
    }
    return self;
}

- (void)didClickOneView:(id)sender{
    UIButton * clickedBtn=(UIButton *)sender;
    CategoryView * clickedView=(CategoryView *)clickedBtn.superview;
    if (self.selectedView!=clickedView) {
        [UIView animateWithDuration:0.3 animations:^{
            [clickedView highlight];
            [self.selectedView downplay];
        }];
        self.selectedView=clickedView;
    }
}

@end
