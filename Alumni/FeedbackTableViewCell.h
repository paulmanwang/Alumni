//
//  FeedbackTableViewCell.h
//  XLAlbumMaster
//
//  Created by wanglichun on 15/1/28.
//  Copyright (c) 2015年 CSD iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackTableViewCell : UITableViewCell

+(FeedbackTableViewCell*)feedbackTableViewCell;
+ (CGFloat)cellHeightWithData:(id)data;
- (void)fillData:(id)data;

@end
