//
//  SpinningImageView.m
//  iThunder
//
//  Created by xunlei on 1/21/13.
//  Copyright (c) 2013 xunlei.com. All rights reserved.
//

#import "SpinningImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define REG_NOTIFY(s, n) [[NSNotificationCenter defaultCenter] addObserver:self selector:s name:n object:nil];

@implementation SpinningImageView

- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Speed:(CGFloat)sp
{
    self=[super init];
    if (self){
        self.frame=frame;
        self.image=image;
        self.speed=sp;
        self.isLoading = NO;
        self.isClockWise = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.speed = 0.5;
        self.isLoading = NO;
        self.isClockWise = YES;
    }
    return self;
}

- (void)setSpeed:(CGFloat)speed
{
    if (speed >= 1.0f){
        speed = 1.0f-FLT_MIN;
    }else if (speed<=0.0f){
        speed  = FLT_MIN;
    }
    _speed = speed;
}


- (void)setRotation{
    if (nil!=[self.layer animationForKey:@"transform"]){
        return;
    }
 
    CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    if (self.isClockWise) {
        animation.fromValue=@0.0f;
        animation.toValue=[NSNumber numberWithFloat:M_PI*2];
    } else {
        animation.fromValue=[NSNumber numberWithFloat:M_PI*2];
        animation.toValue=@0.0f;
    }
    animation.duration=10*(1-self.speed);
    animation.repeatCount=FLT_MAX;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate=self;
    [self.layer removeAllAnimations];
    
    if(self.changeAlpha){
        CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim2.duration = 10*(1-self.speed);
        anim2.fromValue = [NSNumber numberWithFloat:1.f];
        anim2.toValue = [NSNumber numberWithFloat:0.1f];
        anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anim2.repeatCount = CGFLOAT_MAX;
        anim2.autoreverses = YES;
       [self.layer addAnimation:anim2 forKey:@"opacity"];
    }
    
    [self.layer addAnimation:animation forKey:@"transform"];
}

- (void)startSpinAnimating{
    if (_speed!=0.0f&&NO==self.hidden){
        [self setRotation];
        self.isLoading = YES;
    }
}

- (void)stopSpinAnimating{
    [self.layer removeAllAnimations];
    self.isLoading = NO;
}

- (void)setHidden:(BOOL)hidden{
//    XLLog(@"hidden-%d",hidden);
    [super setHidden:hidden];
    if (NO==hidden){
        [self startSpinAnimating];
    }else{
        [self stopSpinAnimating];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (nil!=newSuperview){
        REG_NOTIFY(@selector(appDidLaunch:), UIApplicationWillEnterForegroundNotification);
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

}

- (void)appDidLaunch:(NSNotification*)notification{
    if (self.isLoading) {
        [self startSpinAnimating];
    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

//影响动画播放
////动画放完了（几乎不会出现）或中断了（hidden，stop），删除之，好让setRotation的判断准确些，保证必要的时候显示动画的前提下不会重复开始动画而出现跳跃的现象
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    [self.layer removeAllAnimations];
//}

@end