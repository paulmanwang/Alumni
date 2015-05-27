//
//  ContactTableViewCell.m
//  Alumni
//
//  Created by wanglichun on 15/1/5.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "ContactTableViewCell.h"
#include "UIView+X.h"

@implementation ContactTableViewCell


- (void)awakeFromNib {
    // Initialization code
}


+(ContactTableViewCell*)contactTableViewCell{
    return [UIView viewWithNib:@"ContactTableViewCell" owner:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    UIColor *whiteColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //下分割线
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end
