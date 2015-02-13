//
//  SquareTableViewCell.m
//  Alumni
//
//  Created by wanglichun on 15/2/9.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "SquareTableViewCell.h"
#import "UIView+X.h"

@interface  SquareTableViewCell()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SquareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(SquareTableViewCell*)squareTableViewCell{
    return [UIView viewWithNib:@"SquareTableViewCell" owner:nil];
}

- (void)setContent:(NSString *)content
{
    self.contentTextView.text = content;
}
@end
