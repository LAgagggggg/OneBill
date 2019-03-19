//
//  TodaySayingView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/10/2.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "TodaySayingView.h"
#import <Masonry.h>

@implementation TodaySayingView

- (instancetype)initWithLine:(NSArray<NSString *> *)lines
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UILabel * labelUpon;
        BOOL firstLine=YES;
        for (NSString * line in lines) {
            if (firstLine) {
                firstLine=NO;
                UILabel * label=[[UILabel alloc]init];
                [self addSubview:label];
                label.font=[UIFont fontWithName:@"HelveticaNeue" size:16];
                label.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1];
                label.textAlignment=NSTextAlignmentCenter;
                label.text=line;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX);
                    make.top.equalTo(self.mas_top);
                }];
                label.backgroundColor=self.backgroundColor;
                UILabel * quoteLabel=[[UILabel alloc]init];
                [self addSubview:quoteLabel];
                quoteLabel.text=@"“";
                quoteLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:32];
                quoteLabel.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1];
                [quoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(label.mas_centerY).with.offset(5);
                    make.left.equalTo(label.mas_left).with.offset(-30);
                }];
                quoteLabel.backgroundColor=self.backgroundColor;
                labelUpon=label;
            }
            else{
                UILabel * label=[[UILabel alloc]init];
                [self addSubview:label];
                label.font=[UIFont fontWithName:@"HelveticaNeue" size:16];
                label.textColor=[UIColor colorWithRed:111/255.0 green:117/255.0 blue:117/255.0 alpha:1];
                label.textAlignment=NSTextAlignmentCenter;
                label.text=line;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.mas_centerX);
                    make.top.equalTo(labelUpon.mas_bottom);
                }];
                label.backgroundColor=self.backgroundColor;
                labelUpon=label;
            }
        }
    }
    return self;
}

@end
