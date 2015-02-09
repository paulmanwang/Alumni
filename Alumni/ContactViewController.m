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
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    CGRect frame = self.contactTableView.frame;
    NSLog(@"viewDidLoad x = %f, y = %f, width = %f, height = %f", frame.origin.x,
          frame.origin.y, frame.size.width, frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect superFrame = self.view.superview.frame;
    NSLog(@"super frame x = %f, y = %f, width = %f, height = %f", superFrame.origin.x, superFrame.origin.y, superFrame.size.width, superFrame.size.height);
    
    CGRect frame = self.view.frame;
    NSLog(@"ContactViewController viewDidAppear x = %f, y = %f, width = %f, height = %f", frame.origin.x,
          frame.origin.y, frame.size.width, frame.size.height);
    self.contactTableView.frame = CGRectMake(self.contactTableView.frame.origin.x, self.contactTableView.frame.origin.y, frame.size.width, frame.size.height - 44);
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect frame = self.view.frame;
    NSLog(@"ContactViewController viewDidAppear x = %f, y = %f, width = %f, height = %f", frame.origin.x,
          frame.origin.y, frame.size.width, frame.size.height);
    self.contactTableView.frame = CGRectMake(self.contactTableView.frame.origin.x, self.contactTableView.frame.origin.y, frame.size.width, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
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
