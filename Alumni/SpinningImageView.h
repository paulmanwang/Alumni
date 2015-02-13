//
//  SpinningImageView.h
//  iThunder
//
//  Created by xunlei on 1/21/13.
//  Copyright (c) 2013 xunlei.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinningImageView : UIImageView

@property (nonatomic) CGFloat speed;//0<speed<1,默认0.5
@property (nonatomic) BOOL isLoading;
//默认值是YES
@property (nonatomic) BOOL isClockWise;

@property (nonatomic) BOOL changeAlpha;

- (void)startSpinAnimating;
- (void)stopSpinAnimating;
- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Speed:(CGFloat)sp;

@end
