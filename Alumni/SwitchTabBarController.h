//
//  SwitchTabBarController.h
//  switchTabBarDemo
//
//  Created by 张培川 on 13-8-1.
//  Copyright (c) 2013年 张培川. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SwitchTabBar.h"
@class UITabBarController;
@protocol SwitchTabBarControllerDelegate;
@interface SwitchTabBarController : UIViewController <SwitchTabBarDelegate>
{
    SwitchTabBar        *_tabBar;
	UIView              *_containerView;
	UIView              *_transitionView;
    
    NSMutableArray      *_viewControllers;
	NSUInteger          _selectedIndex;
	
	BOOL                _tabBarTransparent;
	BOOL                _tabBarHidden;
}
@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) SwitchTabBar *tabBar;
@property(nonatomic,assign) id<SwitchTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
-(void)setSelectedIndex:(NSUInteger)index;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
@end
@protocol SwitchTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(SwitchTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(SwitchTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (SwitchTabBarControllerSupport)
@property(nonatomic, retain, readonly) SwitchTabBarController *switchTabBarController;
@end
