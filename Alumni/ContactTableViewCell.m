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

@end
