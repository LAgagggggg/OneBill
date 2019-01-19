//
//  PopUpDateSelectView.m
//  OneBill
//
//  Created by LAgagggggg on 2019/1/19.
//  Copyright © 2019 ookkee. All rights reserved.
//

#import "PopUpDateSelectView.h"

@interface PopUpDateSelectView()

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIView * dateSelectViewWrapperView;
@property (nonatomic, strong) UIView * dateSelectView;
@property (nonatomic, strong) UIButton * changeRangeButton;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@implementation PopUpDateSelectView

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=[[UIView alloc]init];
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backgroundView.backgroundColor=[UIColor colorWithRed:6/255.0 green:34/255.0 blue:54/255.0 alpha:0.5];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundClicked)];
        [self.backgroundView addGestureRecognizer:tap];
        
        self.dateSelectViewWrapperView=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-288, self.bounds.size.width, 288)];
        [self addSubview:self.dateSelectViewWrapperView];
        
        self.dateSelectView=[[UIView alloc]init];
        [self.dateSelectViewWrapperView addSubview:self.dateSelectView];
        [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateSelectViewWrapperView.mas_left).with.offset(8);
            make.right.equalTo(self.dateSelectViewWrapperView.mas_right).with.offset(-8);
            make.top.equalTo(self.dateSelectViewWrapperView.mas_top);
            make.height.mas_equalTo(213);
        }];
        self.dateSelectView.backgroundColor=[UIColor whiteColor];
        self.dateSelectView.layer.cornerRadius=10;
        
        UILabel * hintLable=[[UILabel alloc]init];
        [self.dateSelectView addSubview:hintLable];
        [hintLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dateSelectView.mas_centerX);
            make.centerY.equalTo(self.dateSelectView.mas_top).with.offset(25);
        }];
        hintLable.text=@"Show bills during …";
        hintLable.font=[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        hintLable.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.3];
        hintLable.textAlignment=NSTextAlignmentCenter;
        
        CALayer * separateLine=[CALayer layer];
        [self.dateSelectView.layer addSublayer:separateLine];
        separateLine.frame=CGRectMake(0, 45, self.dateSelectView.bounds.size.width, 1);
        separateLine.backgroundColor=[UIColor colorWithRed:222/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
        
        self.changeRangeButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.dateSelectView addSubview:self.changeRangeButton];
        [self.changeRangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dateSelectView.mas_centerX);
            make.top.equalTo(self.dateSelectView.mas_top).with.offset(56);
            make.height.mas_equalTo(16);
            make.width.mas_greaterThanOrEqualTo(60);
        }];
        self.changeRangeButton.tintColor=OB_DarkBlueColor;
        [self.changeRangeButton setTitle:@"Month" forState:UIControlStateNormal];
        self.changeRangeButton.titleLabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        
        self.datePicker=[[UIDatePicker alloc]init];
        [self.dateSelectView addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateSelectView.mas_left);
            make.right.equalTo(self.dateSelectView.mas_right);
            make.bottom.equalTo(self.dateSelectView.mas_bottom).with.offset(-0);
            make.top.equalTo(self.changeRangeButton.mas_bottom).with.offset(0);
        }];
        self.datePicker.datePickerMode=UIDatePickerModeDate;
        
        self.cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.dateSelectViewWrapperView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.dateSelectView.mas_width);
            make.top.equalTo(self.dateSelectView.mas_bottom).with.offset(8);
            make.height.mas_equalTo(56);
            make.centerX.equalTo(self.dateSelectView.mas_centerX);
        }];
        self.cancelButton.backgroundColor=[UIColor whiteColor];
        self.cancelButton.layer.cornerRadius=10;
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.cancelButton.tintColor=OB_DarkBlueColor;
        self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundView.alpha=0;
        self.dateSelectViewWrapperView.frame=CGRectMake(0, self.frame.size.height, self.bounds.size.width, 288);
        self.alpha=0;
    }
    return self;
}

#pragma mark - event response

- (void)popUp{
    self.alpha=1;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundView.alpha=1;
        self.dateSelectViewWrapperView.frame=CGRectMake(0, self.bounds.size.height-288, self.bounds.size.width, 288);
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundView.alpha=0;
        self.dateSelectViewWrapperView.frame=CGRectMake(0, self.frame.size.height, self.bounds.size.width, 288);
    } completion:^(BOOL finished) {
        self.alpha=0;
    }];
}

- (void)backgroundClicked{
    [self dismiss];
}

- (void)cancelButtonClicked{
    [self dismiss];
}


@end
