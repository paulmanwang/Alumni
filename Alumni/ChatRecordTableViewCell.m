//
//  ChatRecordTableViewCell.m
//  Alumni
//
//  Created by wanglichun on 15/2/9.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "ChatRecordTableViewCell.h"
#include "UIView+X.h"

@implementation ChatRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(ChatRecordTableViewCell*)chatRecordTableViewCell{
    return [UIView viewWithNib:@"ChatRecordTableViewCell" owner:nil];
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
