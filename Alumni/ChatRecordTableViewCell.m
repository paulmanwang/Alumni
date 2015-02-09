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

@end
