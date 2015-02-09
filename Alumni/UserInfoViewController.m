//
//  UserInfoViewController.m
//  Alumni
//
//  Created by wanglichun on 15/1/5.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIBarButtonItem+X.h"

@interface UserInfoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect frame = self.nickNameLabel.frame;
    NSLog(@"UserInfoViewController viewDidAppear x = %f, y = %f, width = %f, height = %f", frame.origin.x,
          frame.origin.y, frame.size.width, frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
