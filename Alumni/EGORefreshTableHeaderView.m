//
//  EGORefreshTableHeaderView.m
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

#import "EGORefreshTableHeaderView.h"
#import "UIColor+X.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define EGO_TRIGGER_OFFSET      60.0f
#define EGO_TRIGGER_PLUS        5.0f

@interface EGORefreshTableHeaderView (Private)
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 25.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor colorWithHexString:@"#999999"];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel = label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 45.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor colorWithHexString:@"#444444"];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		//label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(_lastUpdatedLabel.center.x - 125.0f, frame.size.height - 40.0f, 28.0f, 28.0f);
      
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"refresh_arrow"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

		view.frame = CGRectMake(_lastUpdatedLabel.center.x - 125.0f, frame.size.height - 40.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:EGOOPullRefreshNormal];
		
        self.hidden = YES;
    }
	
    return self;
	
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _activityView.frame = CGRectMake(_lastUpdatedLabel.center.x - 125.0f, self.frame.size.height - 40.0f, 20.0f, 20.0f);
    _arrowImage.frame = CGRectMake(_lastUpdatedLabel.center.x - 125.0f, self.frame.size.height - 40.0f, 28.0f, 28.0f);
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
    
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		NSDate *date = [self.delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"AM"];
//		[formatter setPMSymbol:@"PM"];
//		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
        NSString* strTime = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新时间：%@", strTime];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = @"释放立即刷新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = @"下拉刷新...";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = @"载入中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
    _state = aState;
//    if ([XLReachabilityHelper sharedInstance].currentReachabilityStatus == kXLNotReachable)
//    {
//        _statusLabel.text = @"网络不可用，无法刷新";
//        _arrowImage.hidden = YES;
//        [self syncTask:^{
//            if (_state != EGOOPullRefreshNormal)
//            {
//                self.state = EGOOPullRefreshNormal;
//            }
//        }];
//    }
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)setOriginalScrollViewContentInset:(UIEdgeInsets)originalScrollViewContentInset{
    _originalScrollViewContentInset  = originalScrollViewContentInset;
}

- (CGFloat)getScrollViewOffsetCheckValue
{
    return -(self.originalScrollViewContentInset.top + EGO_TRIGGER_OFFSET + EGO_TRIGGER_PLUS);
}

- (void)updateSelfHiddenStateOnScrollView:(UIScrollView *)scrollView
{
    self.hidden = (scrollView.contentOffset.y >= -self.originalScrollViewContentInset.top);
    //NSLog(@"%s %f | %f", __FUNCTION__,scrollView.contentOffset.y,-self.originalScrollViewContentInset.top);
}

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
//		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//		offset = MIN(offset, EGO_TRIGGER_OFFSET);
//        UIEdgeInsets insets = self.originalScrollViewContentInset;
//        insets.top += offset;
//		scrollView.contentInset = insets;
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > [self getScrollViewOffsetCheckValue] && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < [self getScrollViewOffsetCheckValue] && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != self.originalScrollViewContentInset.top) {
			scrollView.contentInset = self.originalScrollViewContentInset;
		}
        [self updateSelfHiddenStateOnScrollView:scrollView];
	}
    else
    {
        [self updateSelfHiddenStateOnScrollView:scrollView];
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    [self egoRefreshScrollViewDidEndDragging:scrollView force:NO];
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView force:(BOOL)force{
	
	BOOL _loading = NO;
	if ([delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if ((scrollView.contentOffset.y <= [self getScrollViewOffsetCheckValue] && !_loading) || force) {
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        UIEdgeInsets insets = self.originalScrollViewContentInset;
        insets.top += EGO_TRIGGER_OFFSET;
		scrollView.contentInset = insets;
		[UIView commitAnimations];
		
        if ([delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    //有时候下面的动画会把tableView卡死，所以暂时去掉了。
    //[UIView animateWithDuration:.3 animations:^{
        scrollView.contentInset = self.originalScrollViewContentInset;
   // } completion:^(BOOL finished) {
        [self updateSelfHiddenStateOnScrollView:scrollView];
   // }];
	[self setState:EGOOPullRefreshNormal];
}

- (void)egoRestoreScrollView:(UIScrollView*)scrollView{
    scrollView.contentInset = self.originalScrollViewContentInset;
    //scrollView.contentOffset = CGPointMake(scrollView.frame.origin.x, scrollView.frame.origin.y);
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end
