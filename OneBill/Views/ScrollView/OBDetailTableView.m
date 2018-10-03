//
//  OBDetailTableView.m
//  OneBill
//
//  Created by LAgagggggg on 2018/10/3.
//  Copyright © 2018 ookkee. All rights reserved.
//

#import "OBDetailTableView.h"

@implementation OBDetailTableView

- (void)addSubview:(UIView *)view{
    if ([view isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
        view.backgroundColor=[UIColor clearColor];
        view.layer.cornerRadius=10.f;
        view.layer.masksToBounds=YES;
        UIView * deleteBtn=view.subviews[0];
        deleteBtn.layer.cornerRadius=10.f;
        deleteBtn.layer.masksToBounds=YES;
    }
    [super addSubview:view];
}

@end
