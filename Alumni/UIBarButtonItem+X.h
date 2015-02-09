//
//  UIBarButtonItem+X.h
//  iThunder
//
//  Created by xunlei on 5/2/13.
//  Copyright (c) 2013 xunlei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (X)

// 如果customView是一个button则能返回这个button,否则为nil
- (UIButton*)customViewButton;

@end
