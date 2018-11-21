//
//  OBMainButton.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/18.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBMainButton.h"
#import <Masonry.h>

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]

@interface OBMainButton()
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIButton * Button;
@end

@implementation OBMainButton

- (instancetype)initWithType:(OBButtonType)type
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
        if (type==OBButtonTypeAdd) {
            self.backgroundColor=[UIColor whiteColor];
            //左侧icon
            self.icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_add_b"]];
            self.icon.contentMode=UIViewContentModeCenter;
            [self addSubview:self.icon];
            [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(22));
                make.height.equalTo(self.icon.mas_width);
                make.left.equalTo(self.mas_left).with.offset(23);
                make.centerY.equalTo(self.mas_centerY);
            }];
            //分割线
            UIView * lineView=[[UIView alloc]init];
            lineView.backgroundColor=DarkCyanColor;
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.centerX.equalTo(self.icon.mas_centerX).with.offset(27);
                make.width.equalTo(@(1));
                make.height.equalTo(self.icon.mas_height).dividedBy(2);
            }];
            //右侧文字
            self.label=[[UILabel alloc]init];
            self.label.text=@"Add One Bill";
            self.label.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1];
            [self addSubview:self.label];
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(lineView.mas_right).with.offset(17);
            }];
        }
        else if (type==OBButtonTypeCheck) {
            self.backgroundColor=DarkBlueColor;
            //左侧icon
            self.icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_ok_w"]];
            self.icon.contentMode=UIViewContentModeScaleAspectFit;
            [self addSubview:self.icon];
            [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(22));
                make.height.equalTo(self.icon.mas_width);
                make.left.equalTo(self.mas_left).with.offset(23);
                make.centerY.equalTo(self.mas_centerY);
            }];
            //分割线
            UIView * lineView=[[UIView alloc]init];
            lineView.backgroundColor=DarkCyanColor;
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.centerX.equalTo(self.icon.mas_centerX).with.offset(27);
                make.width.equalTo(@(1));
                make.height.equalTo(self.icon.mas_height).dividedBy(2);
            }];
            //右侧文字
            self.label=[[UILabel alloc]init];
            self.label.text=@"Check Bills";
            self.label.textColor=[UIColor whiteColor];
            [self addSubview:self.label];
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(lineView.mas_right).with.offset(17);
            }];
        }
        //添加按钮效果
        self.Button=[UIButton buttonWithType:UIButtonTypeCustom];
        self.Button.backgroundColor=[UIColor clearColor];
        [self addSubview:self.Button];
        [self.Button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        [self.Button addTarget:self action:@selector(buttonDim) forControlEvents:UIControlEventTouchDown];
        [self.Button addTarget:self action:@selector(buttonBright) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside ];
    }
    return self;
}

- (void)layoutSubviews{
    //shadowPath
    [super layoutSubviews];
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.f];
    [self.layer setShadowPath:shadowPath.CGPath];
}

- (void)buttonDim{
    self.alpha=0.7;
}

- (void)buttonBright{
    self.alpha=1;
}

-(void)addTarget:(id)tar action:(SEL)sel forControlEvents:(UIControlEvents)event{
    [self.Button addTarget:tar action:sel forControlEvents:event];
}

- (void)cancelHighlight{
    self.Button.highlighted=NO;
    [self buttonBright];
}

@end
