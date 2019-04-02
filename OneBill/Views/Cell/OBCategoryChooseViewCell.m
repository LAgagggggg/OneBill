//
//  OBCategoryChooseViewCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/7/28.
//  Copyright © 2018 ookkee. All rights reserved.
//
#define LightGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]

#import "OBCategoryChooseViewCell.h"

@implementation OBCategoryChooseViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.label=[[UILabel alloc]init];
        self.label.font=[UIFont fontWithName:@"HelveticaNeue" size:18];
        self.label.textColor=LightGrayColor;
        self.label.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

//上下间距
- (void)setFrame:(CGRect)frame{
    frame.origin.y += 19;
    frame.size.height -= 19;
    [super setFrame:frame];
}

- (void)highlight{
    [self.label setTextColor:DarkBlueColor];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
}

- (void)downplay{
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [self.label setTextColor:LightGrayColor];
}

@end
