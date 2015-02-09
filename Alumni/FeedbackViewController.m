//
//  MyFeedbackViewController.m
//  XLAlbumMaster
//
//  Created by wanglichun on 15/1/28.
//  Copyright (c) 2015年 CSD iOS. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackItem.h"
#import "FeedbackTableViewCell.h"
#import "UIView+X.h"

static NSString *TipsString = @"请输入聊天内容";

@interface FeedbackViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray  *_feedbackItems;
    NSTimer         *_timer;
    NSDateFormatter *_dataFormatter;
    
    NSUInteger       _feedbackCount;
    BOOL             _isFirstTime;
    NSUInteger       _numOfLine;
    CGFloat          _originTextViewHeight;
    CGFloat          _originTextViewWidth;
    CGFloat          _originTableViewHeight;
    CGFloat          _originInputBgHeight;
    CGRect           _originSendContainerFrame;
    CGFloat          _lastContentSize;
    CGFloat          _lastContentLen;
    CGFloat          _keyboardHeight;
    NSString        *_lastFeedback;
    BOOL             _isTimerStarted;
}

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *inputBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIView *sendContainerView;

@end

@implementation FeedbackViewController

- (id)init
{
    self = [super init];
    if (self) {
        _feedbackItems = [[NSMutableArray alloc] init];
        _dataFormatter = [[NSDateFormatter alloc] init];
        _feedbackCount = 0;
        _isFirstTime   = YES;
        _numOfLine     = 0;
        _lastContentSize = 0.0f;
        _originTextViewHeight = 0.0f;
        
        [_dataFormatter setDateFormat:@"MM/dd HH:mm"];
        _isTimerStarted = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"西门吹雪";
    self.sendButton.enabled = NO;
    
    //设置输入框的边框
    self.contentTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.contentTextView.layer.borderWidth = 1;
    self.contentTextView.layer.cornerRadius = 4;
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.textColor = [UIColor lightGrayColor];
    self.contentTextView.text = TipsString;
    self.contentTextView.scrollsToTop = NO;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    _originTextViewHeight = self.contentTextView.frame.size.height;
    _originTextViewWidth = self.contentTextView.frame.size.width;
    _originTableViewHeight = self.tableView.frame.size.height;
    _originInputBgHeight = self.inputBgImageView.frame.size.height;
    _originSendContainerFrame = self.sendContainerView.frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([_lastFeedback length] > 0) {
        [self.contentTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - keyboard

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (_isFirstTime && [_lastFeedback length] == 0) {
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.text = nil;
        _isFirstTime = NO;
    }
    
    self.backgroundButton.hidden = NO;
   
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat distanceNeedToScroll = keyboardRect.size.height;
    _keyboardHeight = distanceNeedToScroll;
    
    CGFloat upDist = self.contentTextView.frame.size.height - _originTextViewHeight;
    CGRect sendContainerFrame = self.sendContainerView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.sendContainerView.frame = CGRectMake(_originSendContainerFrame.origin.x,
                                                  _originSendContainerFrame.origin.y - distanceNeedToScroll - upDist,
                                                  _originSendContainerFrame.size.width,
                                                  sendContainerFrame.size.height);
    }];
    self.tableView.height = _originTableViewHeight - distanceNeedToScroll - upDist;
    self.backgroundButton.height = _originTableViewHeight - distanceNeedToScroll - upDist;
    [self scrollTableViewToBottom];
}

- (void)keyboardDidHidden:(NSNotification *)aNotification
{
    _keyboardHeight = 0;
}

#pragma mark - inner logic methods

- (void)startQueryTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(requestFeedbackInfo) userInfo:nil repeats:YES];
}

- (void)stopQueryTimer
{
    [_timer invalidate];
}


- (void)saveDevFeedbackToDB:(NSMutableArray *)feedbackInfo
{
    NSUInteger devFeedbackCount = feedbackInfo.count - _feedbackItems.count;
    NSMutableArray *devFeedbacks = [[NSMutableArray alloc] init];
    for (NSInteger i = devFeedbackCount; i > 0; i--) {
        NSMutableDictionary *dict = feedbackInfo[feedbackInfo.count - i];
        FeedbackItem *item = [FeedbackItem initWithParameterDictionary:dict];
        [_feedbackItems addObject:item];
        [devFeedbacks addObject:item];
    }
}


- (void)scrollTableViewToBottom
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)refreshTableViewWithFeedbackInfo:(NSMutableArray *)feedbackInfo
{
    [_feedbackItems removeAllObjects];
    for (NSInteger i = 0; i < feedbackInfo.count; i++) {
        NSMutableDictionary *dict = feedbackInfo[i];
        FeedbackItem *item = [FeedbackItem initWithParameterDictionary:dict];
        [_feedbackItems addObject:item];
    }
    
    _feedbackCount = feedbackInfo.count;
    [self.tableView reloadData];
    [self scrollTableViewToBottom];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedbackItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *feedbackTableViewCellIdentifer = @"FeedbackTableViewCellIdentifer";
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedbackTableViewCellIdentifer];
    if(!cell){
        cell = [FeedbackTableViewCell feedbackTableViewCell];
    }
    
    [cell fillData:_feedbackItems[indexPath.row]];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedbackTableViewCell cellHeightWithData:_feedbackItems[indexPath.row]];
}

#pragma mark - Button actions

- (IBAction)backgroundButtonTouchDown:(id)sender
{
    self.backgroundButton.hidden = YES;
    [self.contentTextView resignFirstResponder];
    CGFloat upDist = self.contentTextView.height - _originTextViewHeight;
    self.tableView.frame = CGRectMake(0, 0,self.tableView.width, _originTableViewHeight - upDist);
    self.backgroundButton.frame = CGRectMake(0, 0,self.tableView.width, _originTableViewHeight - upDist);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sendContainerView.frame = CGRectMake(_originSendContainerFrame.origin.x,
                                                  _originSendContainerFrame.origin.y - upDist,
                                                  _originSendContainerFrame.size.width,
                                                  _originSendContainerFrame.size.height + upDist);
    }];
}

- (void)setTextViewToBottomWithOption:(BOOL)isNeedToAdjustHeight
{
    CGFloat upDist = self.contentTextView.height - _originTextViewHeight;
    if (isNeedToAdjustHeight){
        //还原到初始位置
        CGRect sendContainerViewFrame = self.sendContainerView.frame;
        self.sendContainerView.frame = CGRectMake(sendContainerViewFrame.origin.x,
                                                  sendContainerViewFrame.origin.y + upDist,
                                                  sendContainerViewFrame.size.width,
                                                  _originSendContainerFrame.size.height);
        
        self.contentTextView.height = _originTextViewHeight;
    }
    
    if (isNeedToAdjustHeight) {
        self.tableView.frame = CGRectMake(0, 0, self.tableView.width, _originTableViewHeight);
        self.backgroundButton.frame = CGRectMake(0, 0, self.tableView.width, _originTableViewHeight);
        [UIView animateWithDuration:0.2 animations:^{
            self.sendContainerView.frame = _originSendContainerFrame;
        }];
    }else{
        self.tableView.frame = CGRectMake(0, 0, self.tableView.width, _originTableViewHeight - upDist);
        self.backgroundButton.frame = CGRectMake(0, 0, self.tableView.width, _originTableViewHeight - upDist);
        CGRect sendContainerViewFrame = self.sendContainerView.frame;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.sendContainerView.frame = CGRectMake(_originSendContainerFrame.origin.x,
                                                      _originSendContainerFrame.origin.y - upDist,
                                                      sendContainerViewFrame.size.width,
                                                      sendContainerViewFrame.size.height);
        }];
    }
    
    [self.contentTextView resignFirstResponder];
}

//保存服务器的反馈信息至服务器
- (void)saveUserFeedbackToDB
{
    //将发送的反馈信息添加至tableview中显示
    NSString *currentTime = [_dataFormatter stringFromDate:[NSDate date]];
    FeedbackItem *item = [FeedbackItem initWithContent:self.contentTextView.text time:currentTime];
    [_feedbackItems addObject:item];
    _feedbackCount++;
    [self.tableView reloadData];
    [self scrollTableViewToBottom];
}

- (IBAction)onSendButtonClicked:(id)sender
{
    self.sendButton.enabled = NO;
    
    if (_keyboardHeight > 0) {
        [self.contentTextView resignFirstResponder];
        self.tableView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height + _keyboardHeight);
        self.backgroundButton.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height + _keyboardHeight);
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.sendContainerView.frame;
            self.sendContainerView.frame = CGRectMake(0, frame.origin.y + _keyboardHeight, frame.size.width, frame.size.height);
        }];
    }
    
    //发送反馈信息
    [self setTextViewToBottomWithOption:YES];
    [self saveUserFeedbackToDB];
}

//动态调整输入框的高度
- (void)adjustTextViewHeight:(CGFloat)upDist
{
    CGRect sendContainerViewFrame = self.sendContainerView.frame;
    self.sendContainerView.frame = CGRectMake(_originSendContainerFrame.origin.x,
                                              sendContainerViewFrame.origin.y - upDist,
                                              sendContainerViewFrame.size.width,
                                              sendContainerViewFrame.size.height + upDist);
    self.contentTextView.height = self.contentTextView.height + upDist;
    self.tableView.height = self.tableView.height - upDist;
    self.backgroundButton.height = self.tableView.height - upDist;
    [self scrollTableViewToBottom];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.contentTextView.text length] == 0
        || [[self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        self.sendButton.enabled = NO;
    }else{
        self.sendButton.enabled = YES;
    }
    
    if (textView.contentSize.height == _lastContentSize) {
        NSLog(@"返回了");
        return;
    }
    
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(_originTextViewWidth, FLT_MAX)];
    if (size.height > self.contentTextView.font.lineHeight * 5) {
        return;
    }
    
    CGFloat upDist = size.height - self.contentTextView.height;
    [self adjustTextViewHeight:upDist];
    _lastContentLen = textView.contentSize.height;
}

@end
