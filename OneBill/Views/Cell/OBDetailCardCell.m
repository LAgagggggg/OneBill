//
//  OBTableViewCardCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/23.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBDetailCardCell.h"
#import <masonry.h>

#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface OBDetailCardCell()
@property (strong,nonatomic)UILabel * timeLabel;
@property (strong,nonatomic)UILabel * valueLabel;
@property (strong,nonatomic)UILabel * locLabel;
@end

@implementation OBDetailCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //高亮状态
        self.selectedBackgroundView.layer.cornerRadius=10.f;
        self.selectedBackgroundView.layer.masksToBounds=YES;
        //UI
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 3;
        self.timeLabel=[[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.timeLabel setTextColor:textGrayColor];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(24.6);
            make.top.equalTo(self.contentView.mas_top).with.offset(19);
        }];
        UILabel * moneyLabel=[[UILabel alloc]init];
        [moneyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:36]];
        [moneyLabel setTextColor:DarkBlueColor];
        moneyLabel.text=@"¥";
        [self.contentView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel.mas_left);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.valueLabel=[[UILabel alloc]init];
        [self.valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:36]];
        [self.valueLabel setTextColor:textGrayColor];
        [self.contentView addSubview:self.valueLabel];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyLabel.mas_right).with.offset(9.7);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.categoryBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        self.categoryBtn.tintColor=DarkBlueColor;
//        self.categoryBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 13, 0, 13);
        self.categoryBtn.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        self.categoryBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        self.categoryBtn.layer.cornerRadius=10.f;
        self.categoryBtn.layer.borderWidth=1;
        self.categoryBtn.layer.borderColor=DarkBlueColor.CGColor;
        [self.contentView addSubview:self.categoryBtn];
        [self.categoryBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.categoryBtn.mas_left).with.offset(8);
            make.right.equalTo(self.categoryBtn.mas_right).with.offset(-8);
            make.centerY.equalTo(self.categoryBtn.mas_centerY);
        }];
        [self.categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-17);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.height.equalTo(@(24));
        }];
        self.locLabel=[[UILabel alloc]init];
        [self.locLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.locLabel setTextColor:textGrayColor];
        [self.locLabel setTextAlignment:NSTextAlignmentRight];
        self.locLabel.alpha=0.5;
        [self.contentView addSubview:self.locLabel];
        [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.right.equalTo(self.contentView.mas_right).with.offset(-16);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16);
        }];
    }
    return self;
}

- (void)setCellWithBill:(OBBill *)bill andStylePreference:(OBTimeLabelPreference)preference{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (preference==OBTimeLibelTimeOnly) {
        dateFormatter.dateFormat = @"HH:mm";
    }
    else if(preference==OBTimeLibelWithDate){
        dateFormatter.dateFormat = @"HH:mm, MMM d";
    }
    self.timeLabel.text=[dateFormatter stringFromDate:bill.date];
    double value= bill.isOut? -bill.value:bill.value;
    self.valueLabel.text=[NSString stringWithFormat:@"%+.2lf",value];
    [self.categoryBtn setTitle:bill.category forState:UIControlStateNormal];
    self.locLabel.text=bill.locDescription;
    if (self.locLabel.text.length==0) {
        self.locLabel.text=@"No Location Information";
    }
}

- (void)setFrame:(CGRect)frame{
    
    if (@available(iOS 11, *)) {
        frame.origin.y += 8;
        frame.size.height -= 8;
        frame.origin.x += 30;
        frame.size.width -= 60;
    }//适配iOS11以下的左滑删除
    else if(!self.frameSolidFlag){//初始时为frame定型
        if (!self.frameSetFlag && frame.size.height >=50 && self.timeLabel.text!=nil) {//ugly
            self.frameSetFlag=1;
            self.solidFrame=frame;
        }
        frame.origin.y=self.solidFrame.origin.y+8;
        frame.size.height=self.solidFrame.size.height-8;
        frame.origin.x=self.solidFrame.origin.x+30;
        frame.size.width=self.solidFrame.size.width-60;
        if (self.frameSetFlag) {
            self.frameSolidFlag=1;
        }
    }
    else{//其他frame改变时只会横向改变，只需更改x
        frame.origin.x += 30;
        frame.size.width=self.solidFrame.size.width-60;
    }
    if(self.isEditing){//editing的cell需要重新定型
        frame.origin.y=self.solidFrame.origin.y+8;
        frame.size.height=self.solidFrame.size.height-8;
        frame.origin.x=self.solidFrame.origin.x+30;
        frame.size.width=self.solidFrame.size.width-60;
    }
    [super setFrame:frame];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //prevent off-screen render
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    self.layer.shadowPath=shadowPath.CGPath;
    
    if (@available(iOS 11,*)) {//deleteBtn for the cell under iOS11 will be set here
    }
    else{
        for (UIView *subview in self.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] )
            {
                subview.backgroundColor=[UIColor clearColor];
                subview.layer.cornerRadius=10.f;
                subview.layer.masksToBounds=YES;
                UIView * deleteBtn=subview.subviews[0];
                deleteBtn.layer.cornerRadius=10.f;
                deleteBtn.layer.masksToBounds=YES;
            }
        }
    }
}

@end
