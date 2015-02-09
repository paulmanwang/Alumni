//
//  FeedbackTableViewCell.m
//  XLAlbumMaster
//
//  Created by wanglichun on 15/1/28.
//  Copyright (c) 2015年 CSD iOS. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "FeedbackItem.h"
#import "UIView+X.h"


static const CGFloat ExtraHeight                 = 40.0f;
static const CGFloat StandardScreenWidth         = 320.0f;

static const CGFloat TimeLabelHeight             = 20.0f;
static const CGFloat ContentLabelWith            = 167.0f;
static const CGFloat ContentLabelTopMargin       = 10.0f;
static const CGFloat ContentLabelLeftMargin      = 12.0f;
static const CGFloat EdgeDist                    = 10.0f;

@interface  FeedbackTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *leftTimeContainer;
@property (weak, nonatomic) IBOutlet UIView *rightTimeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *leftContentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightContentImageView;

@end

@implementation FeedbackTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(FeedbackTableViewCell*)feedbackTableViewCell{
    return [UIView viewWithNib:@"FeedbackTableViewCell" owner:nil];
}

+ (CGFloat)cellHeightWithData:(id)data
{
    return [FeedbackTableViewCell calculateLabelSizeWithData:data].height + TimeLabelHeight + ExtraHeight;
}

+ (CGSize)calculateLabelSizeWithData:(id)data
{
    FeedbackItem *item = (FeedbackItem *)data;
    
    CGRect rect = [ UIScreen mainScreen].applicationFrame;
    CGFloat width = rect.size.width * ContentLabelWith / StandardScreenWidth;
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [item.feedbackContent sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (void)fillData:(id)data
{
    FeedbackItem *item = (FeedbackItem *)data;
    NSLog(@"item feedbackContent = %@", item.feedbackContent);
    CGSize labelSize = [FeedbackTableViewCell calculateLabelSizeWithData:data];
    labelSize.height = labelSize.height + 1; //1像素误差的BUG
    
    if (item.feedbackType == FeedbackType_Developer) {
        self.rightContentLabel.hidden = YES;
        self.rightTimeContainer.hidden = YES;
        self.rightContentImageView.hidden = YES;
        self.leftContentLabel.hidden = NO;
        self.leftContentImageView.hidden = NO;
        CGRect contentImageViewFrame = self.leftContentImageView.frame;
        self.leftContentImageView.frame = CGRectMake(contentImageViewFrame.origin.x,
                                                     contentImageViewFrame.origin.y,
                                                     labelSize.width + 2 * ContentLabelLeftMargin,
                                                     labelSize.height + 2 * ContentLabelTopMargin);
        
        CGRect contentLabelFrame = self.leftContentLabel.frame;
        self.leftContentLabel.frame = CGRectMake(contentLabelFrame.origin.x, contentLabelFrame.origin.y,
                                                 labelSize.width, labelSize.height);
        
        self.leftContentLabel.text = item.feedbackContent;
        self.leftTimeLabel.text = item.feedbackTime;
    }else{
        self.leftContentLabel.hidden = YES;
        self.leftTimeContainer.hidden = YES;
        self.leftContentImageView.hidden = YES;
        self.rightContentLabel.hidden = NO;
        self.rightContentImageView.hidden = NO;
        
        CGRect contentImageViewFrame = self.rightContentImageView.frame;
        CGFloat x1 = self.contentView.width - labelSize.width - EdgeDist - 2 * ContentLabelLeftMargin;
        self.rightContentImageView.frame = CGRectMake(x1, contentImageViewFrame.origin.y,
                                                      labelSize.width + 2 * ContentLabelLeftMargin,
                                                      labelSize.height + 2 * ContentLabelTopMargin);
        
        CGRect contentLabelFrame = self.rightContentLabel.frame;
        CGFloat x2 = self.contentView.width - labelSize.width - EdgeDist - ContentLabelLeftMargin;
        self.rightContentLabel.frame = CGRectMake(x2, contentLabelFrame.origin.y,
                                                  labelSize.width, labelSize.height);
        
        self.rightContentLabel.text = item.feedbackContent;
        self.rightTimeLabel.text = item.feedbackTime;
    }
}

@end
