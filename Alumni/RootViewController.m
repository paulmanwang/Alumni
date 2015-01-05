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

@interface RootViewController ()
{
    SwitchTabBarController *_switchTabBarController;
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
    contactViewController.view.backgroundColor = [UIColor redColor];
    contactViewController.title = @"通讯录";
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    contactNav.navigationBarHidden = YES;
    
    //广场
    UIViewController *squareViewController = [[UIViewController alloc] init];
    squareViewController.view.backgroundColor = [UIColor greenColor];
    squareViewController.title = @"广场";
    UINavigationController *squareNav = [[UINavigationController alloc] initWithRootViewController:squareViewController];
    squareNav.navigationBarHidden = YES;
    
    //聊天
    UIViewController *talkViewController = [[UIViewController alloc] init];
    talkViewController.view.backgroundColor = [UIColor yellowColor];
    talkViewController.title = @"聊天";
    UINavigationController *talkNav = [[UINavigationController alloc] initWithRootViewController:talkViewController];
    talkNav.navigationBarHidden = YES;
    
    //设置
    UIViewController *settingViewController = [[UIViewController alloc] init];
    settingViewController.view.backgroundColor = [UIColor blueColor];
    settingViewController.title = @"设置";
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    settingNav.navigationBarHidden = YES;
    
    
    NSArray *ctrlArr = [NSArray arrayWithObjects:contactNav,talkNav, squareNav,settingNav,nil];

    NSArray *imgArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"tab_bar_contact"],[UIImage imageNamed:@"tab_bar_talk"],[UIImage imageNamed:@"tab_bar_square"],[UIImage imageNamed:@"tab_bar_setting"], nil];
    
    _switchTabBarController = [[SwitchTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    [_switchTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"mainpage_bottombg"]];
    [_switchTabBarController setTabBarTransparent:YES];
    [self.view addSubview:_switchTabBarController.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
