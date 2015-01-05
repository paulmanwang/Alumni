//
//  SwitchTabBar.m
//
//  Created by wanglichun 2015.01.05
//  Copyright (c) 2015年 wanglichun. All rights reserved.
//

#import "SwitchTabBar.h"
static const int TABS_PER_ROW = 4;
static const int TAB_Btn_Height = 45;

@implementation SwitchTabBar

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];

		backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        
		[self addSubview:backgroundImage];
        [self addSubview:downImageView];
        
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
		CGFloat width = 320.0f / TABS_PER_ROW;
		for (int i = 0; i < [imageArray count]; i++)
		{
            NSInteger index = i % TABS_PER_ROW;
            NSInteger page = i / TABS_PER_ROW;
            
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i;
			btn.frame = CGRectMake(width * index , page*frame.size.height +5, width, TAB_Btn_Height);
			[btn setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
			[btn setImage:[imageArray objectAtIndex:i] forState:UIControlStateSelected];
            
			[btn setBackgroundImage:[UIImage imageNamed:@"tab_bar_selected"] forState:UIControlStateSelected];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"tab_bar_selected"] forState:UIControlStateHighlighted];
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.buttons addObject:btn];
            [self addSubview:btn];
		}
    }
    return self;
}
- (void)setBackgroundImage:(UIImage *)img
{
	[backgroundImage setImage:img];
    [downImageView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
}
- (void)selectTabAtIndex:(NSInteger)index
{
    for (int i = 0; i < [self.buttons count]; i++)
    {
        UIButton *b = [self.buttons objectAtIndex:i];
        b.selected = NO;
    }
    UIButton *btn = [self.buttons objectAtIndex:index];
    btn.selected = YES;
    currentSelectButton = index;
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
    NSLog(@"Select index: %d",btn.tag);
}

@end
