//
//  CategoryView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryView.h"
#import <Masonry.h>

#define MuchLightGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:0.5]
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]

@interface CategoryView()
@end


@implementation CategoryView

- (instancetype)initWithCategory:(NSString *)text
{
    self = [super init];
    if (self) {
        //凹形状
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=10.f;
        self.frame=CGRectMake(0, 0, 30, 42);
        self.layer.shadowColor=[UIColor grayColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 5);
        self.layer.shadowOpacity=0.1;
        self.layer.shadowRadius=3;
        //label
        self.label=[[UILabel alloc]init];
        [self.label setText:text];
        [self.label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.label setTextColor:MuchLightGrayColor];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setNumberOfLines:1];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.mas_top).with.offset(14);
            make.bottom.equalTo(self.mas_bottom).with.offset(-14);
        }];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_left).with.offset(-24);
            make.right.equalTo(self.label.mas_right).with.offset(24);
        }];
        self.button=[UIButton buttonWithType:UIButtonTypeCustom];
        self.button.backgroundColor=[UIColor clearColor];
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

- (void)highlight{
    self.backgroundColor=DarkBlueColor;
    [self.label setTextColor:[UIColor whiteColor]];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
}

- (void)downplay{
    self.backgroundColor=[UIColor whiteColor];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    [self.label setTextColor:MuchLightGrayColor];
}

@end
