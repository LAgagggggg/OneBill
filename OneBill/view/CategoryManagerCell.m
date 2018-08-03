//
//  CategoryManagerCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManagerCell.h"
#import "../model/CategoryManager.h"
#import <masonry.h>
#import <MBProgressHUD.h>

#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerCell()
@property (strong,nonatomic)NSString * oldValue;
@property(strong,nonatomic)UIButton * checkIconBtn;
@end

static float animationDuration=0.3;
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
//        UIImage *image= [MyUtil imageWithImage:[UIImage imageNamed:@"MyImage"] scaledToSize:CGSizeMake(80, 80)];
//
//        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        imgView.contentMode = UIViewContentModeCenter;
//        [imgView setImage:image];
        self.checkIconBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkIconBtn setImage:[UIImage imageNamed:@"categoryCheckIcon"] forState:UIControlStateNormal];
        [self.checkIconBtn setImageEdgeInsets:UIEdgeInsetsMake(3,3,3,3)];
        [self.contentView addSubview:self.checkIconBtn];
        [self.checkIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-23);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(14));
            make.height.equalTo(@(14));
        }];
        self.checkIconBtn.backgroundColor=[UIColor whiteColor];
        self.checkIconBtn.layer.cornerRadius=7.f;
        self.checkIconBtn.layer.borderWidth=1.f;
        self.checkIconBtn.layer.masksToBounds=YES;
        self.checkIconBtn.layer.borderColor=DarkBlueColor.CGColor;
        self.checkIconBtn.imageView.hidden=YES;
        self.checkIconBtn.hidden=YES;
        self.checkIconBtn.userInteractionEnabled=NO;
    }
    return self;
}

- (void)setWithCategory:(NSString *)category{
    self.categoryTextField.text=category;
}

- (void)editCategory{
    self.categoryTextField.userInteractionEnabled=YES;
    [self.categoryTextField becomeFirstResponder];
    self.oldValue=self.categoryTextField.text;
    [self.categoryTextField addTarget:self action:@selector(didEndEditingCategory:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)didEndEditingCategory:(UITextField *)textField{
    if (textField.text.length==0) {
        textField.text=self.oldValue;
    }
    else if (![textField.text isEqualToString:self.oldValue]){
        NSString * hudText;
        if ([[CategoryManager sharedInstance] replaceCategory:self.oldValue withNewCategory:textField.text]) {
            hudText=@"Category Successfully Edited ";
        }
        else{
            hudText=@"Category Already Existed";
        }
        MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.label.text=hudText;
        [hud hideAnimated:YES afterDelay:1];
        
    }
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 14;
    frame.size.height -= 14;
//    frame.origin.x += 37;
//    frame.size.width -= 37*2;
    [super setFrame:frame];
}

#pragma mark - about multi delete
- (void)beginMultiDelete{
    self.editBtn.hidden=YES;
    self.checkIconBtn.hidden=NO;
}

- (void)endMultiDelete{
    self.editBtn.hidden=NO;
    self.checkIconBtn.hidden=YES;
}

- (void)multiDeleteBeSelected{
    
}

- (void)multiDeleteBeDeselected{
    
}

@end
