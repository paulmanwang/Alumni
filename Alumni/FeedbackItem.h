//
//  FeedbackItem.h
//  XLAlbumMaster
//
//  Created by wanglichun on 15/1/28.
//  Copyright (c) 2015年 CSD iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FeedbackType)
{
    FeedbackType_User = 0,
    FeedbackType_Developer = 1
};

@interface FeedbackItem : NSObject

@property (nonatomic, strong)NSString *feedbackID;
@property (nonatomic, strong)NSString *feedbackTime;
@property (nonatomic, strong)NSString *feedbackContent;
@property (nonatomic, assign)FeedbackType feedbackType;

+ (FeedbackItem *)initWithParameterDictionary:(NSDictionary *)replyInfo;
+ (FeedbackItem *)initWithContent:(NSString *)content time:(NSString *)time;
- (NSDictionary*)storageDictionary:(NSDictionary*)options;

@end
