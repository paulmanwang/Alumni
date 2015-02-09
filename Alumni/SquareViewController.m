//
//  SqureViewController.m
//  Alumni
//
//  Created by wanglichun on 15/2/9.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareTableViewCell.h"

static NSString *squareTableViewCellIdentifier = @"SquareTableViewCellIdentifier";

@interface SquareViewController ()

@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareTableViewCell *squareCell = [tableView dequeueReusableCellWithIdentifier:squareTableViewCellIdentifier];
    if (!squareCell) {
        squareCell = [SquareTableViewCell squareTableViewCell];
    }
    
    return squareCell;
}

@end
