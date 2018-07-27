//
//  OBCategoryScrollView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/20.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBCategoryScrollView.h"
#import "../model/OBBillManager.h"
#import "../model/CategoryManager.h"
#import <masonry.h>
#import <MBProgressHUD.h>

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
        self.cViewArr=[[NSMutableArray alloc]init];
        self.sumLabelView=[[UIView alloc]init];
        [self addSubview:self.sumLabelView];
        [self.sumLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.height.equalTo(@(16));
        }];
        for (NSString * category in categoriesArr) {
            CategoryView * cView=[[CategoryView alloc]initWithCategory:category];
            UILabel * sumLabel=[[UILabel alloc]init];
            sumLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
            sumLabel.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.5];
            sumLabel.text=[NSString stringWithFormat:@"¥%+.2lf",[[OBBillManager sharedInstance] sumOfCategory:category InMonthOfDate:[NSDate date]]];
            sumLabel.textAlignment=NSTextAlignmentCenter;
            [self.sumLabelView addSubview:sumLabel];
            [cView layoutIfNeeded];
            needWidth+=cView.frame.size.width;
            [self addSubview:cView];
            [cView.button addTarget:self action:@selector(didClickOneView:) forControlEvents:UIControlEventTouchUpInside];
            if (i!=0) {
                needWidth+=21;
                CategoryView * lastView=self.cViewArr.lastObject;
                [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(26);
                    make.left.equalTo(lastView.mas_right).with.offset(21);
                }];
            }
            else{
                needWidth+=30;
                [cView highlight];
                self.selectedView=cView;
                self.currentCategory=cView.label.text;
                [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(26);
                    make.left.equalTo(self.mas_left).with.offset(30);
                }];
            }
            [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sumLabelView.mas_top);
                make.centerX.equalTo(cView.mas_centerX);
            }];
            i++;
            [self.cViewArr addObject:cView];
        }
        CategoryView * cView=[[CategoryView alloc]initWithCategory:@"+"];
        self.addTextField=[[UITextField alloc]init];
        self.addTextField.font=cView.label.font;
        self.addTextField.textColor=cView.label.textColor;
        self.addTextField.textAlignment=NSTextAlignmentCenter;
        self.addTextField.placeholder=@"+";
        self.addTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        self.addTextField.autocorrectionType=UITextAutocorrectionTypeNo;
        [self.addTextField addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
        cView.label.hidden=YES;
        [cView addSubview:self.addTextField];
        [self.addTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cView.mas_left);
            make.right.equalTo(cView.mas_right);
            make.centerY.equalTo(cView.mas_centerY);
        }];
        [self addSubview:cView];
        [cView layoutIfNeeded];
        needWidth+=21;
        needWidth+=100;
        CategoryView * lastView=self.cViewArr.lastObject;
        [cView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(26);
            make.left.equalTo(lastView.mas_right).with.offset(21);
        }];
        self.contentSize=CGSizeMake(needWidth+20, 88);
        self.sumLabelView.frame=CGRectMake(0,0,needWidth+20,16);
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
        self.currentCategory=clickedView.label.text;
    }
}

-(void)textFieldDidEndEditing{
    if(self.addTextField.text.length ){
        if (![[NSSet setWithArray:[CategoryManager sharedInstance].categoriesArr] containsObject:self.addTextField.text]) {
            [[CategoryManager sharedInstance].categoriesArr addObject:self.addTextField.text];
            [[CategoryManager sharedInstance]writeToFile];
            float needWidth=self.contentSize.width;
            CategoryView * cView=[[CategoryView alloc]initWithCategory:self.addTextField.text];
            [self.addTextField.superview removeFromSuperview];
            needWidth-=121;
            [self addSubview:cView];
            [cView.button addTarget:self action:@selector(didClickOneView:) forControlEvents:UIControlEventTouchUpInside];
            [cView layoutIfNeeded];
            needWidth+=21;
            needWidth+=cView.frame.size.width;
            CategoryView * lastView=self.cViewArr.lastObject;
            [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(26);
                make.left.equalTo(lastView.mas_right).with.offset(21);
            }];
            UILabel * sumLabel=[[UILabel alloc]init];
            sumLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
            sumLabel.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.5];
            sumLabel.text=[NSString stringWithFormat:@"¥%+.2lf",[[OBBillManager sharedInstance] sumOfCategory:cView.label.text InMonthOfDate:[NSDate date]]];
            sumLabel.textAlignment=NSTextAlignmentCenter;
            [self.sumLabelView addSubview:sumLabel];
            [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sumLabelView.mas_top);
                make.centerX.equalTo(cView.mas_centerX);
            }];
            [self.cViewArr addObject:cView];
            cView=[[CategoryView alloc]initWithCategory:@"+"];
            self.addTextField=[[UITextField alloc]init];
            self.addTextField.font=cView.label.font;
            self.addTextField.textColor=cView.label.textColor;
            self.addTextField.textAlignment=NSTextAlignmentCenter;
            self.addTextField.placeholder=@"+";
            [self.addTextField addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
            cView.label.hidden=YES;
            [cView addSubview:self.addTextField];
            [self.addTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cView.mas_left);
                make.right.equalTo(cView.mas_right);
                make.centerY.equalTo(cView.mas_centerY);
            }];
            [self addSubview:cView];
            [cView layoutIfNeeded];
            needWidth+=21;
            needWidth+=100;
            lastView=self.cViewArr.lastObject;
            [cView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(26);
                make.left.equalTo(lastView.mas_right).with.offset(21);
            }];
            self.contentSize=CGSizeMake(needWidth, 88);
            self.sumLabelView.frame=CGRectMake(0,0,needWidth,16);
        }
        else{
            self.addTextField.text=@"";
            MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"Category Already Existed";
            [hud hideAnimated:YES afterDelay:1.5];
        }
    }
}


@end
