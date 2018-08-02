//
//  CategoryManagerCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManagerCell.h"
#import <masonry.h>

#define DarkCyanColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:224/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerCell()
@end

@implementation CategoryManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //UI
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=10.f;
        self.layer.shadowColor=[UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,3);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 12;
        //文字
        self.categoryTextField=[[UITextField alloc]init];
        self.categoryTextField.autocorrectionType=UITextAutocorrectionTypeNo;
        self.categoryTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        self.categoryTextField.enablesReturnKeyAutomatically=YES;
        self.categoryTextField.userInteractionEnabled=NO;
        [self.categoryTextField setTextColor:textGrayColor];
        [self.categoryTextField setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [self.contentView addSubview:self.categoryTextField];
        [self.categoryTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(41);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.editBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.editBtn setImage:[UIImage imageNamed:@"categoryEditBtn"] forState:UIControlStateNormal];
        self.editBtn.tintColor=textGrayColor;
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-23);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.editBtn addTarget:self action:@selector(editCategory) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setWithCategory:(NSString *)category{
    self.categoryTextField.text=category;
}

- (void)editCategory{
    self.categoryTextField.userInteractionEnabled=YES;
    [self.categoryTextField becomeFirstResponder];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 14;
    frame.size.height -= 14;
    frame.origin.x += 37;
    frame.size.width -= 37*2;
    [super setFrame:frame];
}

@end
