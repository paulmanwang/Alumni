//
//  SqureViewController.m
//  Alumni
//
//  Created by wanglichun on 15/2/9.
//  Copyright (c) 2015年 thunder. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareTableViewCell.h"
#import "EGORefreshTableFooterView.h"
#import <objc/runtime.h>

static NSString *squareTableViewCellIdentifier = @"SquareTableViewCellIdentifier";

@interface SquareViewController()<UIScrollViewDelegate, EGORefreshTableFooterDelegate>
{
    EGORefreshTableFooterView *_refreshFooterView;
    NSMutableArray *_infomations;
    NSUInteger _infoCount;
    BOOL _isScanningData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_infomations) {
        _infomations = [[NSMutableArray alloc] init];
    }
    
    for (NSInteger i = 0; i < 10; i++) {
        _infoCount++;
        NSString *str = [[NSString alloc] initWithFormat:@"测试%d", _infoCount];
        [_infomations addObject:str];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFooterView{
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infomations.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareTableViewCell *squareCell = [tableView dequeueReusableCellWithIdentifier:squareTableViewCellIdentifier];
    if (!squareCell) {
        squareCell = [SquareTableViewCell squareTableViewCell];
    }
    
    NSString *content = _infomations[indexPath.row];
    [squareCell setContent:content];
    
    return squareCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_refreshFooterView){
        [self setFooterView];
    }
    
    if (_infoCount == 50) {
         [_refreshFooterView egoRefreshScrollViewDidScroll:self.tableView isScanning:NO];
    }else{
         [_refreshFooterView egoRefreshScrollViewDidScroll:self.tableView isScanning:YES];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
    if (_isScanningData == NO) {
        [self loadMoreData];
    }
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    _isScanningData = YES;
    dispatch_block_t block = ^{
        for (NSInteger i = 0; i < 10; i++) {
             [NSThread sleepForTimeInterval:1];
            _infoCount++;
            NSString *str = [[NSString alloc] initWithFormat:@"测试%d", _infoCount];
            [_infomations addObject:str];
        }
        
        dispatch_block_t mainBlock = ^{
            [self.tableView reloadData];
            [_refreshFooterView existRefresh:self.tableView];
            _isScanningData = NO;
        };
        dispatch_async(dispatch_get_main_queue(), mainBlock);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    
}


@end
