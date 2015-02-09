//
//  FeedbackItem.m
//  XLAlbumMaster
//
//  Created by wanglichun on 15/1/28.
//  Copyright (c) 2015年 CSD iOS. All rights reserved.
//

#import "FeedbackItem.h"

@implementation FeedbackItem

+ (FeedbackItem *)initWithParameterDictionary:(NSDictionary *)replyInfo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm"];
    
    FeedbackItem *item = [[FeedbackItem alloc] init];
    long long secs = [replyInfo[@"created_at"] longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    item.feedbackTime = [dateFormatter stringFromDate:date];
    item.feedbackContent = replyInfo[@"content"];

    if ([replyInfo[@"type"] isEqualToString:@"user_reply"]) {
        item.feedbackType = FeedbackType_User;
    }else{
        item.feedbackType = FeedbackType_Developer;
    }
    
    return item;
}

+ (FeedbackItem *)initWithContent:(NSString *)content time:(NSString *)time
{
    FeedbackItem *item = [[FeedbackItem alloc] init];
    item.feedbackContent = content;
    item.feedbackTime = time;
    item.feedbackType = FeedbackType_User;
    
    return item;
}

- (NSDictionary*)storageDictionary:(NSDictionary*)options;
{
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    
    [pairs setObject:self.feedbackID forKey:@"feedbackID"];
    [pairs setObject:self.feedbackTime forKey:@"feedbackTime"];
    [pairs setObject:self.feedbackContent forKey:@"feedbackContent"];
    [pairs setObject:[NSNumber numberWithInteger:self.feedbackType] forKey:@"feedbackType"];
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
