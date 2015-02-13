//
//  RootViewController.m
//  Alumni
//
//  Created by wanglichun on 15/1/4.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "RootViewController.h"
#import "SwitchTabBarController.h"
#import "ContactViewController.h"
#import "ChatRecordViewController.h"
#import "SettingViewController.h"
#import "SquareViewController.h"

@interface RootViewController ()
{
    SwitchTabBarController *_switchTabBarController;
    UITabBarController *_tabBarController;
}

@end

@implementation RootViewController

// 通过这个方法访问唯一对象
+ (RootViewController*)sharedInstance
{
    static RootViewController* sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    });
    NSAssert(sharedObj, @"why RootViewController sharedInstance = nil");
    return sharedObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar
{
    //通讯录
    ContactViewController *contactViewController = [[ContactViewController alloc] init];
    contactViewController.title = @"校友录";
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    contactNav.tabBarItem.title = @"校友录";
    contactNav.tabBarItem.image = [UIImage imageNamed:@"tab_bar_contact"];
    
    //广场
    UIViewController *squareViewController = [[SquareViewController alloc] init];
    squareViewController.view.backgroundColor = [UIColor greenColor];
    squareViewController.title = @"广场";
    UINavigationController *squareNav = [[UINavigationController alloc] initWithRootViewController:squareViewController];
    squareNav.tabBarItem.title = @"广场";
    squareNav.tabBarItem.image = [UIImage imageNamed:@"tab_bar_square"];
    
    //聊天
    UIViewController *chatRecordViewController = [[ChatRecordViewController alloc] init];
    chatRecordViewController.view.backgroundColor = [UIColor yellowColor];
    chatRecordViewController.title = @"聊天";
    UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatRecordViewController];
    chatNav.tabBarItem.title = @"聊天";
    chatNav.tabBarItem.image = [UIImage imageNamed:@"tab_bar_talk"];
    
    //设置
    UIViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.title = @"个人信息";
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    settingNav.tabBarItem.title = @"设置";
    settingNav.tabBarItem.image = [UIImage imageNamed:@"tab_bar_setting"];
    
    //a.初始化一个tabBar控制器
    _tabBarController=[[UITabBarController alloc]init];
    _tabBarController.viewControllers=@[contactNav, squareNav, chatNav,settingNav];
    [self.view addSubview:_tabBarController.view];
    
//    NSArray *ctrlArr = [NSArray arrayWithObjects:contactNav, chatNav, squareNav,settingNav,nil];
//
//    NSArray *imgArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"tab_bar_contact"],[UIImage imageNamed:@"tab_bar_talk"],[UIImage imageNamed:@"tab_bar_square"],[UIImage imageNamed:@"tab_bar_setting"], nil];
//    
//    _switchTabBarController = [[SwitchTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
//    [_switchTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"mainpage_bottombg"]];
//    [_switchTabBarController setTabBarTransparent:YES];
//    [self.view addSubview:_switchTabBarController.view];
}

@end
