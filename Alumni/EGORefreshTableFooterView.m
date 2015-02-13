//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"
#import "SpinningImageView.h"
#import "UIColor+X.h"
#import "UIView+X.h"

#define EGORefreshTableFooterTriggerOffset     30

@interface EGORefreshTableFooterView ()
{
    UIActivityIndicatorView* _activity;
    SpinningImageView* _spiningImageView;
    UIView* _tipAndActivityContainView;
}
@end

@implementation EGORefreshTableFooterView


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
        UIImageView* backgroundView = [[UIImageView alloc] init];
        backgroundView.frame = self.bounds;
        UIImage* image = [UIImage imageNamed:@"albumController_background"];
        backgroundView.image = image;
       // [self addSubview:backgroundView];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _icoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-logo-end"]];
        //_icoView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 25)/2, 0, 25, 25);
        _icoView.frame = CGRectMake(17, 0, 18, 18);
        
        
        //_tipAndActivityContainView = [[UIView alloc] initWithFrame:CGRectMake(0, _icoView.bottom, 320, 25)];
        _tipAndActivityContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        [_tipAndActivityContainView setBackgroundColor:[UIColor clearColor]];
        
        _spiningImageView = [[SpinningImageView alloc] initWithFrame:CGRectMake(19, 0.5*(19 - 13), 13, 13)];
        _spiningImageView.image = [UIImage imageNamed:@"first_page_spinningImage"];
        _spiningImageView.changeAlpha = NO;
        _spiningImageView.isClockWise = YES;
        _spiningImageView.speed = 0.9;
        _spiningImageView.hidden = YES;
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icoView.right+5, 0, [UIScreen mainScreen].bounds.size.width, 19)];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.text = @"暂无更多";
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.backgroundColor = [UIColor clearColor];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        _tipLabel.alpha = 0.3;
        [_tipLabel setTextColor:[UIColor blackColor]];
        
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([self getActivityLeft], 0, 25, 25)];
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        
        [_tipAndActivityContainView addSubview:_tipLabel];
        [_tipAndActivityContainView addSubview:_activity];
        
        [self addSubview: _icoView];
        [self addSubview:_tipAndActivityContainView];
        [self addSubview:_spiningImageView];
       
    }
    return self;
}

- (CGFloat)getActivityLeft {
    CGFloat labelTextWidth = [_tipLabel.text sizeWithFont:_tipLabel.font].width;
    return ([UIScreen mainScreen].bounds.size.width - labelTextWidth)/2 - 25 -10;
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:nil];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
}



#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView isScanning:(BOOL)scanning{
    if(scrollView.contentSize.height < scrollView.height){
        self.top = scrollView.height;
        if (scanning) {
            self.top = scrollView.contentSize.height;
        }
    }else{
        self.top = scrollView.contentSize.height;
    }
    if((scrollView.contentOffset.y >= fabsf(scrollView.contentSize.height-scrollView.height)+EGORefreshTableFooterTriggerOffset)&&scanning){
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, EGORefreshTableFooterTriggerOffset, 0);
        //[_activity startAnimating];
        _tipAndActivityContainView.top = 0;
        _tipLabel.text = @"正在扫描中...";
        //_activity.left = [self getActivityLeft];
        _icoView.hidden = YES;
        _spiningImageView.hidden = NO;
        _icoView.hidden = YES;
        [_spiningImageView startSpinAnimating];
        //_icoView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [self.delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
    }else if(scanning){
        //[_activity startAnimating];
        _icoView.hidden = YES;
        _spiningImageView.hidden = NO;
        _tipAndActivityContainView.top = 0;
        _tipLabel.text = @"正在扫描中...";
        //_activity.left = [self getActivityLeft];
         [_spiningImageView startSpinAnimating];
        //_icoView.hidden = YES;
    }else{
       // _tipAndActivityContainView.top = _icoView.bottom;
        _tipAndActivityContainView.top = 0;
        _icoView.hidden = NO;
        _spiningImageView.hidden = YES;
        _tipLabel.text = @"暂无更多";
         //[_spiningImageView stopSpinAnimating];
        //[_spiningImageView startSpinAnimating];
        
//        _activity.left = [self getActivityLeft];
//        [_activity stopAnimating];
    }
}
- (void)existRefresh:(UIScrollView*)scrollview{
    scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if(scrollview.contentSize.height>scrollview.height){
        self.top = scrollview.contentSize.height;
    }else{
        self.top = scrollview.height;
    }
   // NSLog(@"scrollView height = %f",scrollview.height);
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_activityView = nil;
    _icoView = nil;
    _tipLabel = nil;
    _tipAndActivityContainView = nil;
}


@end
