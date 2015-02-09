//
//  UIBarButtonItem+X.m
//  iThunder
//
//  Created by xunlei on 5/2/13.
//  Copyright (c) 2013 xunlei.com. All rights reserved.
//

#import "UIBarButtonItem+X.h"

@implementation UIBarButtonItem (X)

- (UIButton*)customViewButton
{
    if (!self.customView || ![self.customView isKindOfClass:[UIButton class]]) {
        return nil;
    }
    return (UIButton*)self.customView;
}

@end
