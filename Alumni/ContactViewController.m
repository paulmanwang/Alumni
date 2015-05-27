//
//  ContactViewController.m
//  Alumni
//
//  Created by wanglichun on 15/1/5.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactTableViewCell.h"
#import "UserInfoViewController.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contactTableView;

@end

static NSString *contactTableViewCellIdentifier = @"contactTableViewCellIdentifier";
@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *contactCell = [tableView dequeueReusableCellWithIdentifier:contactTableViewCellIdentifier];
    if (!contactCell) {
        contactCell = [ContactTableViewCell contactTableViewCell];
    }
    
    return contactCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

@end
