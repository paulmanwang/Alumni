//
//  SwitchTabBar.h
//
//  Created by wanglichun 2015.01.05
//  Copyright (c) 2015年 wanglichun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwitchTabBarDelegate;

@interface SwitchTabBar : UIView
{
    UIImageView     *backgroundImage;
    UIImageView     *downImageView;
    int             currentSelectButton;
}
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, assign) id<SwitchTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)setBackgroundImage:(UIImage *)img;
- (void)selectTabAtIndex:(NSInteger)index;
@end

@protocol SwitchTabBarDelegate<NSObject>
@optional
- (void)tabBar:(SwitchTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
