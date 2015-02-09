//
//  ChatRecordViewController.m
//  Alumni
//
//  Created by wanglichun on 15/2/9.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "ChatRecordViewController.h"
#import "ChatRecordTableViewCell.h"
#import "FeedbackViewController.h"

static NSString *chatRecordTableViewCellIdentifier = @"ChatRecordTableViewCellIdentifier";

@interface ChatRecordViewController ()

@end

@implementation ChatRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatRecordTableViewCell *chatRecordCell = [tableView dequeueReusableCellWithIdentifier:chatRecordTableViewCellIdentifier];
    if (!chatRecordCell) {
        chatRecordCell = [ChatRecordTableViewCell chatRecordTableViewCell];
    }
    
    return chatRecordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedbackViewController *fbvc = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:fbvc animated:YES];
}

@end
