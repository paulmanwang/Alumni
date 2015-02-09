//
//  SwitchTabBarController.m
//  switchTabBarDemo
//
//  Created by 张培川 on 13-8-1.
//  Copyright (c) 2013年 张培川. All rights reserved.
//

#import "SwitchTabBarController.h"
#define kTabBarHeight 50.0f

static SwitchTabBarController *switchTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (SwitchTabBarController *)switchTabBarController
{
	return switchTabBarController;
}

@end


@interface SwitchTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation SwitchTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;


- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
{
	self = [super init];
	if (self != nil)
	{
		_viewControllers = [NSMutableArray arrayWithArray:vcs];
		
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320.0f, _containerView.frame.size.height - kTabBarHeight+20)];
		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		
		_tabBar = [[SwitchTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
		_tabBar.delegate = self;
		
        switchTabBarController = self;
	}
	return self;
}
- (void)loadView
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedIndex = 0;
}

#pragma mark - instant methods
- (SwitchTabBar *)tabBar
{
	return _tabBar;
}

- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
	}
}

- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    NSLog(@"哈哈哈");
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    NSLog(@"Display View.");
    _selectedIndex = index;
    
	[_transitionView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:nil];
    targetViewController.view.hidden = NO;
	targetViewController.view.frame = _transitionView.frame;
	if ([targetViewController.view isDescendantOfView:_transitionView])
	{
		[_transitionView bringSubviewToFront:targetViewController.view];
	}
	else
	{
		[_transitionView addSubview:targetViewController.view];
	}
}

#pragma mark - tabBar delegates
- (void)tabBar:(SwitchTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
}
@end
