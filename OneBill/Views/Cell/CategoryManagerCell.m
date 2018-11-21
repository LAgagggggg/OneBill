//
//  CategoryManagerCell.m
//  OneBill
//
//  Created by LAgagggggg on 2018/8/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "CategoryManagerCell.h"
#import "OBCategoryManager.h"
#import <masonry.h>
#import <MBProgressHUD.h>

#define DarkBlueColor [UIColor colorWithRed:94/255.0 green:169/255.0 blue:234/255.0 alpha:1]
#define textGrayColor [UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1]

@interface CategoryManagerCell()
@property (nonatomic, strong) NSString * oldValue;
@property(nonatomic, strong) UIButton * checkIconButton;
@property(nonatomic, strong) UIView * deleteLine;
@end

static float animationDuration=0.3;
@implementation CategoryManagerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasHideReorderControl=NO;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //为了拖拽
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(7);
            make.bottom.equalTo(self.mas_bottom).with.offset(-7);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        //UI
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.contentView.layer.cornerRadius=10.f;
        self.contentView.layer.shadowColor=[UIColor whiteColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(3,3);
        self.contentView.layer.shadowOpacity = 0.3;
        self.contentView.layer.shadowRadius = 12;
//        self.contentView.layer.shouldRasterize=YES;
//        self.contentView.layer.rasterizationScale=[UIScreen mainScreen].scale;
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
        self.editButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [self.editButton setImage:[UIImage imageNamed:@"categoryEditButton"] forState:UIControlStateNormal];
        self.editButton.imageEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
        self.editButton.tintColor=textGrayColor;
        [self.contentView addSubview:self.editButton];
        [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-23);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(31));
            make.height.equalTo(@(32));
        }];
        [self.editButton addTarget:self action:@selector(editCategory) forControlEvents:UIControlEventTouchUpInside];
//        UIImage *image= [MyUtil imageWithImage:[UIImage imageNamed:@"MyImage"] scaledToSize:CGSizeMake(80, 80)];
//
//        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        imgView.contentMode = UIViewContentModeCenter;
//        [imgView setImage:image];
        self.checkIconButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkIconButton setImage:[UIImage imageNamed:@"categoryCheckIcon"] forState:UIControlStateNormal];
        [self.checkIconButton setImageEdgeInsets:UIEdgeInsetsMake(3,3,3,3)];
        [self.contentView addSubview:self.checkIconButton];
        [self.checkIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-23);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(14));
            make.height.equalTo(@(14));
        }];
        self.checkIconButton.backgroundColor=[UIColor whiteColor];
        self.checkIconButton.layer.cornerRadius=7.f;
        self.checkIconButton.layer.borderWidth=1.f;
        self.checkIconButton.layer.masksToBounds=YES;
        self.checkIconButton.layer.borderColor=DarkBlueColor.CGColor;
        self.checkIconButton.imageView.alpha=0;
        self.checkIconButton.alpha=0;
        self.checkIconButton.userInteractionEnabled=NO;
        self.deleteLine=[[UIView alloc]init];
        [self.contentView addSubview:self.deleteLine];
        self.deleteLine.backgroundColor=[UIColor whiteColor];
        [self.deleteLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.editButton.mas_left).with.offset(-13);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@(1));
        }];
        self.deleteLine.alpha=0;
        //about drag

    }
    return self;
}

- (void)layoutSubviews{//shadowPath
    [super layoutSubviews];
    UIBezierPath * shadowPath=[UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds cornerRadius:10.f];
    [self.contentView.layer setShadowPath:shadowPath.CGPath];
}

- (void)setWithCategory:(NSString *)category{
    self.categoryTextField.text=category;
}

- (void)editCategory{
    self.categoryTextField.userInteractionEnabled=YES;
    [self.categoryTextField becomeFirstResponder];
    self.oldValue=self.categoryTextField.text;
    UITextField * addingTextField=self.categoryTextField;
    [addingTextField setSelectedTextRange:[addingTextField textRangeFromPosition:addingTextField.beginningOfDocument toPosition:addingTextField.endOfDocument]];
    [self.categoryTextField addTarget:self action:@selector(didEndEditingCategory:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)didEndEditingCategory:(UITextField *)textField{
    if (textField.text.length==0) {
        textField.text=self.oldValue;
    }
    else if (![textField.text isEqualToString:self.oldValue]){
        NSString * hudText;
        if ([[OBCategoryManager sharedInstance] replaceCategory:self.oldValue withNewCategory:textField.text]) {
            hudText=@"Category Successfully Edited";
            [[OBCategoryManager sharedInstance] writeToFile];
        }
        else{
            hudText=@"Category Already Existed";
            textField.text=self.oldValue;
        }
        MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.label.text=hudText;
        [hud hideAnimated:YES afterDelay:0.6];
    }
}

//拖拽时会调用该方法，所以在这不能用
//- (void)setFrame:(CGRect)frame{
//    frame.origin.y += 14;
//    frame.size.height -= 14;
//    [super setFrame:frame];
//}

#pragma mark - about multi delete
- (void)beginMultiDelete{
    self.hasHideReorderControl=NO;
    [UIView animateWithDuration:animationDuration animations:^{
        self.editButton.alpha=0;
        self.checkIconButton.alpha=1;
        self.checkIconButton.imageView.alpha=0;
    }];
    
}

- (void)endMultiDelete{
    self.hasHideReorderControl=NO;
    [self multiDeleteBeDeselected];
    [UIView animateWithDuration:animationDuration animations:^{
        self.editButton.alpha=1;
        self.checkIconButton.alpha=0;
    }];
}

- (void)multiDeleteBeSelected{
    self.isSelected=YES;
    [UIView animateWithDuration:animationDuration animations:^{
        self.contentView.backgroundColor=DarkBlueColor;
        self.contentView.layer.masksToBounds=YES;
        self.deleteLine.alpha=1;
        self.checkIconButton.imageView.alpha=1;
        self.categoryTextField.textColor=[UIColor whiteColor];
    }];
    
}

- (void)multiDeleteBeDeselected{
    self.isSelected=NO;
    [UIView animateWithDuration:animationDuration animations:^{
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.contentView.layer.masksToBounds=NO;
        self.deleteLine.alpha=0;
        self.checkIconButton.imageView.alpha=0;
        self.categoryTextField.textColor=textGrayColor;
    }];
    
}

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    if ([view isMemberOfClass:NSClassFromString(@"UITableViewCellReorderControl")]) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        for (UIImageView * imgView in view.subviews) {
            imgView.image=nil;
        }
    }
}


@end
