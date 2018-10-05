//
//  inoutSwitchButton.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/19.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "InoutSwitchButton.h"
#import <masonry.h>

#define dimColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]

@interface InoutSwitchButton()
@property (strong,nonatomic)UIView * inView;
@property (strong,nonatomic)UIView * outView;
@property (strong,nonatomic)UILabel * inLabel;
@property (strong,nonatomic)UILabel * outLabel;
@end


@implementation InoutSwitchButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, 120, 34);
        //左侧IN按钮
        self.inView=[[UIView alloc]init];
        self.inView.backgroundColor=dimColor;
        self.inView.layer.cornerRadius=10.f;
        self.inView.layer.shadowColor=[UIColor grayColor].CGColor;
        self.inView.layer.shadowOffset=CGSizeMake(0, 5);
        self.inView.layer.shadowOpacity=0.1;
        self.inView.layer.shadowRadius=3;
        [self addSubview:self.inView];
        [self.inView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(@(50));
            make.height.equalTo(@(34));
        }];
        self.inLabel=[[UILabel alloc]init];
        self.inLabel.text=@"IN";
        self.inLabel.textAlignment=NSTextAlignmentCenter;
        self.inLabel.textColor=textGrayColor;
        self.inLabel.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        [self.inView addSubview:self.inLabel];
        [self.inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inView.mas_left);
            make.top.equalTo(self.inView.mas_top);
            make.right.equalTo(self.inView.mas_right);
            make.bottom.equalTo(self.inView.mas_bottom);
        }];
        UIButton * inBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        inBtn.backgroundColor=[UIColor clearColor];
        [inBtn addTarget:self action:@selector(chooseIn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inBtn];
        [inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inView.mas_left);
            make.top.equalTo(self.inView.mas_top);
            make.right.equalTo(self.inView.mas_right);
            make.bottom.equalTo(self.inView.mas_bottom);
        }];
        //分割线
        UIView * separater=[[UIView alloc]init];
        separater.backgroundColor=DarkCyanColor;
        [self addSubview:separater];
        [separater mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inView.mas_right);
            make.centerY.equalTo(self.inView.mas_centerY);
            make.width.equalTo(@(1));
            make.height.equalTo(@(12));
        }];
        //右侧OUT按钮
        self.outView=[[UIView alloc]init];
        self.outView.backgroundColor=[UIColor whiteColor];
        self.outView.layer.cornerRadius=10.f;
        self.outView.layer.shadowColor=[UIColor grayColor].CGColor;
        self.outView.layer.shadowOffset=CGSizeMake(0, 5);
        self.outView.layer.shadowOpacity=0.1;
        self.outView.layer.shadowRadius=3;
        [self addSubview:self.outView];
        [self.outView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(separater.mas_right);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(@(68));
            make.height.equalTo(@(34));
        }];
        self.outLabel=[[UILabel alloc]init];
        self.outLabel.text=@"OUT";
        self.outLabel.textAlignment=NSTextAlignmentCenter;
        self.outLabel.textColor=textGrayColor;
        self.outLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        [self.outView addSubview:self.outLabel];
        [self.outLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.outView.mas_left);
            make.top.equalTo(self.outView.mas_top);
            make.right.equalTo(self.outView.mas_right);
            make.bottom.equalTo(self.outView.mas_bottom);
        }];
        UIButton * outBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        outBtn.backgroundColor=[UIColor clearColor];
        [outBtn addTarget:self action:@selector(chooseOut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:outBtn];
        [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.outView.mas_left);
            make.top.equalTo(self.outView.mas_top);
            make.right.equalTo(self.outView.mas_right);
            make.bottom.equalTo(self.outView.mas_bottom);
        }];
        self.isOut=YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath * inViewShadowPath=[UIBezierPath bezierPathWithRoundedRect:self.inView.bounds cornerRadius:10.f];
    self.inView.layer.shadowPath=inViewShadowPath.CGPath;
    UIBezierPath * outViewShadowPath=[UIBezierPath bezierPathWithRoundedRect:self.outView.bounds cornerRadius:10.f];
    self.outView.layer.shadowPath=outViewShadowPath.CGPath;
}

- (void)chooseIn{
    self.isOut=NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.inView.backgroundColor=[UIColor whiteColor];
        self.inLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.outView.backgroundColor=dimColor;
        self.outLabel.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
    }];
}

- (void)chooseOut{
    self.isOut=YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.outView.backgroundColor=[UIColor whiteColor];
        self.outLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.inView.backgroundColor=dimColor;
        self.inLabel.font=[UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
    }];
}
@end
