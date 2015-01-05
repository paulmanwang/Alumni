//
//  UIViewx.m
//  MemoLite
//
//  Created by czh0766 on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIView+X.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (X)

+(id) viewWithNib:(NSString*)nib owner:(id)owner {
    NSArray* array =[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil];
    return array[0];
}

-(void) offset:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.x += point.x;
    frame.origin.y += point.y;
    self.frame = frame;
}

-(void) setPosition:(CGPoint)position {
    CGRect frame = self.frame;
    frame.origin.x = position.x;
    frame.origin.y = position.y; 
    self.frame = frame;
}

-(void) setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(CGPoint)postion {
    return self.frame.origin;
}

-(CGSize)size {
    return self.frame.size;
}

-(CGPoint)boundsCenter {
    CGSize size = self.bounds.size;
    return CGPointMake(size.width/2, size.height/2);
}

-(float) left {
    return self.frame.origin.x;
}

-(float) top {
    return self.frame.origin.y;
}

-(float) right {
    return [self left] + [self width];
}

-(float) bottom {
    return [self top] + [self height];
}

-(float) width {
    return self.frame.size.width;
}

-(float) height {
    return self.frame.size.height;
}

-(void) setLeft:(float)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame; 
}

-(void) setRight:(float)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

-(void) setTop:(float)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

-(void) setBottom:(float)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(void) setWidth:(float)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame; 
}

-(void) setHeight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;   
}    

-(void) clearSubviews {
    id subviews = self.subviews;
    NSUInteger count = [subviews count];
    for (int i = 0; i < count; i++) {
        [subviews[i] removeFromSuperview];
    }
}

-(UIView*) superviewByCompareProc:(BOOL (^)(UIView* viewToCheck))compareLogic
{
    UIView* superView = self.superview;
    while (superView) {
        if (compareLogic(superView)) {
            return superView;
        }
        superView = superView.superview;
    }
    return nil;
}

-(UIView*) subviewByCompareProc:(BOOL (^)(UIView* viewToCheck))compareLogic
{
    NSArray* subviews = self.subviews;
    for (UIView* view in subviews) {
        if (compareLogic(view)) {
            return view;
        }
    }
    return nil;
}

-(UIView*) traverseSubviewsWithProc:(BOOL (^)(UIView* viewToCheck))traverseProc
{
    NSArray* subviews = self.subviews;
    for (UIView* view in subviews) {
        if (traverseProc(view)) {
            return view;
        }
        UIView* retView = [view traverseSubviewsWithProc:traverseProc];
        if (retView) {
            return retView;
        }
    }
    return nil;
}

-(void) replaceView:(UIView*)view atIndex:(int)index {
    UIView* view0 = [self viewAtIndex:index];
    view.frame = view0.frame;
    [view0 removeFromSuperview];
    [self insertSubview:view atIndex:index];
}

-(UIView*) viewAtIndex:(int)index {
    return (self.subviews)[index];
}

-(void) removeViewAtIndex:(int)index {
    UIView* view = [self viewAtIndex:index];
    [view removeFromSuperview];
}

-(void) transitionToAddSubview:(UIView*)view duration:(NSTimeInterval)duration {
    [self addSubview:view];
    view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1;
    }];
}

-(void) transitionToRemoveFromSuperview:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [self removeFromSuperview];
    }];
}

-(BOOL) pointInsideFrame:(CGPoint)location {
    location.x -= [self left];
    location.y -= [self top];
    return [self pointInside:location withEvent:nil];
}

-(NSUInteger) indexOfView:(UIView*)view {
    return [self.subviews indexOfObject:view];
}

-(UITapGestureRecognizer*)addTapGestureRecognizer:(id)target forAction:(SEL)action {
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

-(UILongPressGestureRecognizer*)addLongPressGestureRecognizer:(id)target forAction:(SEL)action {
    UILongPressGestureRecognizer* recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    return recognizer;
}

- (NSString *)recursiveDescription:(NSString *)tab
{
    NSString *viewDescription = [NSString stringWithFormat:@"%@%@\n", tab, [self description]];
    NSString *subViewDescription = @"";
    NSString *subTab = [NSString stringWithFormat:@"%@  |", tab];
    for (UIView *subView in self.subviews) {
        subViewDescription = [NSString stringWithFormat:@"%@%@", subViewDescription, [subView recursiveDescription:subTab]];
    }
    return [NSString stringWithFormat:@"%@%@", viewDescription, subViewDescription];
}

- (NSString *)recursiveDescription
{
    return [self recursiveDescription:@""];
}

-(void) layoutSubviewsInCenter {
    float width = 0;
    for (UIView* view in self.subviews) {
        if (!view.hidden) {
            width += [view width];
        }
    }
    float offx = ([self width] - width) / 2;
    float offy = [self height] / 2;
    for (UIView* view in self.subviews) {
        if (!view.hidden) {
            float w = [view width];
            view.center = CGPointMake(offx + w / 2, offy);
            offx += w;
        }
    }
}

-(void) applyBarShadowWithOffset:(CGSize)offset
                         opacity:(CGFloat)opacity
                           color:(UIColor*)color
                    shadowRadius:(CGFloat)shadowRadius
                 shouldRasterize:(BOOL)shouldRasterize
{
    if (self == nil) {
        return ;
    }
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shouldRasterize = shouldRasterize;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void) refreshShadowAccordingToRect:(CGRect)rect
{
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

-(void) refreshShadowPathAccordingToBounds
{
    // 解决动画卡顿
    [self refreshShadowAccordingToRect:self.bounds];
}

-(void) applyBarShadowWithOffset:(CGSize)offset
                         opacity:(CGFloat)opacity
                           color:(UIColor*)color
                    shadowRadius:(CGFloat)shadowRadius
{
    [self applyBarShadowWithOffset:offset
                           opacity:opacity
                             color:color
                      shadowRadius:shadowRadius
                   shouldRasterize:YES];
}

-(void) applyBarShadowCopyFromView:(UIView*)view
{
    if (self == nil || view == nil) {
        return ;
    }
    self.layer.shadowOffset = view.layer.shadowOffset;
    self.layer.shadowOpacity = view.layer.shadowOpacity;
    self.layer.shadowColor = view.layer.shadowColor;
    self.layer.shadowRadius = view.layer.shadowRadius;
    self.layer.shouldRasterize = view.layer.shouldRasterize;
    self.layer.rasterizationScale = view.layer.rasterizationScale;
}

-(void) applyRoundCornerWithRadius:(CGFloat)radius
                     masksToBounds:(BOOL)masksToBounds
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = masksToBounds;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void) maskWithRoundCorners:(UIRectCorner)corners
                 widthRadius:(CGFloat)radius
                     forRect:(CGRect)rect
                 borderColor:(UIColor*)borderColor
                 borderWidth:(CGFloat)borderWidth
               masksToBounds:(BOOL)masksToBounds
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners                                                         cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.shouldRasterize = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.mask = maskLayer;
    
    self.layer.masksToBounds = masksToBounds;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // add border or not
    if (!borderColor || borderWidth == 0) {
        CAShapeLayer *borderLayer = [self.layer valueForKey:@"RoundedRectBorderKey"];
        if (borderLayer)
        {
            [borderLayer removeFromSuperlayer];
            [self.layer setNilValueForKey:@"RoundedRectBorderKey"];
        }
        return ;
    }
    CAShapeLayer *borderLayer = [self.layer valueForKey:@"RoundedRectBorderKey"];
    if (!borderLayer)
    {
        borderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:borderLayer];
        [self.layer setValue:borderLayer forKey:@"RoundedRectBorderKey"];
    }
    
    borderLayer.frame = rect;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.fillColor = [[UIColor clearColor] CGColor];
    borderLayer.lineWidth = borderWidth;
    borderLayer.masksToBounds = NO;
    borderLayer.path = maskPath.CGPath;
    borderLayer.shouldRasterize = YES;
    borderLayer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void) maskWithImages:(NSArray*)arrayOfUIImage
{
    if (!arrayOfUIImage) {
        self.layer.mask = nil;
        NSAssert(0, @"mask images should not be empty!");
        return;
    }
    UIGraphicsBeginImageContext(self.bounds.size);
    for (UIImage* img in arrayOfUIImage) {
        [img drawInRect:self.bounds];
    }
    UIImage *destImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.contents = (__bridge id)destImage.CGImage;
    self.layer.mask = maskLayer;
}

-(void) applyRoundMaskWithRoundCenter:(CGPoint)center
                               radius:(CGFloat)radius
{
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithArcCenter:center
                              radius:radius
                              startAngle:(CGFloat)-M_PI_2
                              endAngle:(CGFloat)1.5*M_PI
                              clockwise:YES];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void)applyFadeAnimationWithKey:(NSString*)key duration:(CGFloat)duration
{
    if (self == nil) {
        return ;
    }
    // 下面实现的是淡入的动画效果
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:kCATransitionFade];
    //[animation setSubtype:kCATransitionMoveIn];
    
    [self.layer removeAnimationForKey:key];
    [self.layer addAnimation:animation forKey:key];
}

-(void)applyFadeAnimationWithKey:(NSString*)key
{
    if (self == nil) {
        return ;
    }
    [self applyFadeAnimationWithKey:key duration:0.3f];
}

-(void)fixColorWithPatternImageForBackgroundColor
{
    self.opaque = NO;
    self.layer.opaque = NO;
}

-(void)doPushAnimationFromDirection:(NSString*)kCATransitionFrom
                       originalView:(UIView*)orgView
                           duration:(NSTimeInterval)duration
                    beforeAnimation:(dispatch_block_t)beforeAnimation
                         completion:(void (^)(BOOL finished))completion
{
    static BOOL bIsAnimating = NO;
    if (bIsAnimating == YES) {
        // 上一个动画未完则放入队列
        dispatch_async(dispatch_get_current_queue(), ^{
            [self doPushAnimationFromDirection:kCATransitionFrom originalView:orgView duration:duration beforeAnimation:beforeAnimation completion:completion];
        });
        return ;
    }
    bIsAnimating = YES;
    
    if (beforeAnimation) {
        beforeAnimation();
    }
    
    CGPoint newViewFromCenter = CGPointZero;
    CGPoint newViewToCenter = self.center;
    CGPoint orgViewFromCenter = orgView.center;
    CGPoint orgViewToCenter = CGPointZero;
    CGFloat fNewViewAlpha = self.alpha;
    CGFloat fOrgViewAlpha = orgView.alpha;
    BOOL bDisableAnimation = NO;
    
    if ([kCATransitionFrom isEqualToString:@"L"]) {
        newViewFromCenter = newViewToCenter;
        newViewFromCenter.x -= self.frame.size.width;
        
        orgViewToCenter = orgViewFromCenter;
        orgViewToCenter.x += orgView.frame.size.width;
    }
    else if ([kCATransitionFrom isEqualToString:@"R"]) {
        newViewFromCenter = newViewToCenter;
        newViewFromCenter.x += self.frame.size.width;
        
        orgViewToCenter = orgViewFromCenter;
        orgViewToCenter.x -= orgView.frame.size.width;
    }
    else if ([kCATransitionFrom isEqualToString:@"T"]) {
        newViewFromCenter = newViewToCenter;
        newViewFromCenter.y -= self.frame.size.height;
        
        orgViewToCenter = orgViewFromCenter;
        orgViewToCenter.y += orgView.frame.size.height;
    }
    else if ([kCATransitionFrom isEqualToString:@"B"]) {
        newViewFromCenter = newViewToCenter;
        newViewFromCenter.y += self.frame.size.height;
        
        orgViewToCenter = orgViewFromCenter;
        orgViewToCenter.y -= orgView.frame.size.height;
    }
    else
    {
        bDisableAnimation = YES;
    }
    
    if (!orgView.superview || orgView.hidden || !self.window || !orgView.window) {
        bDisableAnimation = YES;
    }
    
    if (bDisableAnimation) {
        self.hidden = NO;
        orgView.hidden = YES;
        if (completion) {
            completion (NO);
        }
        bIsAnimating = NO;
        return ;
    }
    
    self.alpha = 0.0f;
    self.hidden = NO;
    self.center = newViewFromCenter;
    orgView.center = orgViewFromCenter;
    [UIView animateWithDuration:duration animations:^{
        
        self.center = newViewToCenter;
        orgView.center = orgViewToCenter;
        
        self.alpha = fNewViewAlpha;
        orgView.alpha = 0.0f;
        
    } completion:^(BOOL finished){
        
        orgView.center = orgViewFromCenter;
        orgView.alpha = fOrgViewAlpha;
        orgView.hidden = YES;
        
        if (completion) {
            completion (finished);
        }
        bIsAnimating = NO;
    }];
}

-(void)doShakeAnimationWithOffset:(CGSize)offset
                      repeatCount:(CGFloat)repeatCount
              durationForOneShake:(NSTimeInterval)durationForOneShake
{
    if (!self) {
        return ;
    }
    if (durationForOneShake <= 0) {
        durationForOneShake = 0.05;
    }
    
    CGAffineTransform translateOrg = self.transform;
    CGAffineTransform translateLeft =CGAffineTransformTranslate(self.transform, -offset.width,-offset.height);
    CGAffineTransform translateRight  =CGAffineTransformTranslate(self.transform, offset.width,offset.height);
    
    self.transform = translateLeft;
    
    [UIView animateWithDuration:durationForOneShake delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:repeatCount];
        self.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:durationForOneShake delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform =translateOrg;
            } completion:NULL];
        }
    }];
}

-(id)addMotionEffectWithPositiveX:(CGFloat)positiveX
                        negativeX:(CGFloat)negativeX
                        positiveY:(CGFloat)positiveY
                        negativeY:(CGFloat)negativeY
{
//    if ([UIDevice iosVersion] < 7) {
//        return nil;
//    }
    
    UIInterpolatingMotionEffect *xAxis = nil;
    UIInterpolatingMotionEffect *yAxis = nil;
    
    if (positiveX != 0.0 || negativeX != 0.0)
    {
        xAxis = [[UIInterpolatingMotionEffect alloc]
                 initWithKeyPath:@"center.x"
                 type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-negativeX];
        xAxis.maximumRelativeValue = [NSNumber numberWithFloat:positiveX];
    }
    
    if (positiveY != 0.0 || negativeY != 0.0)
    {
        yAxis = [[UIInterpolatingMotionEffect alloc]
                 initWithKeyPath:@"center.y"
                 type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-negativeY];
        yAxis.maximumRelativeValue = [NSNumber numberWithFloat:positiveY];
    }
    
    if (xAxis || yAxis)
    {
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        NSMutableArray *effects = [[NSMutableArray alloc] init];
        if (xAxis)
        {
            [effects addObject:xAxis];
        }
        
        if (yAxis)
        {
            [effects addObject:yAxis];
        }
        group.motionEffects = effects;
        [self addMotionEffect:group];
        
        return group;
    }
    return nil;
}

-(id)addMotionEffectWithXTilt:(CGFloat)x YTilt:(CGFloat)y
{
//    if ([UIDevice iosVersion] < 7) {
//        return nil;
//    }
    
    UIInterpolatingMotionEffect *xAxis = nil;
    UIInterpolatingMotionEffect *yAxis = nil;
    
    if (x != 0.0)
    {
        xAxis = [[UIInterpolatingMotionEffect alloc]
                 initWithKeyPath:@"center.x"
                 type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = [NSNumber numberWithFloat:-x];
        xAxis.maximumRelativeValue = [NSNumber numberWithFloat:x];
    }
    
    if (y != 0.0)
    {
        yAxis = [[UIInterpolatingMotionEffect alloc]
                 initWithKeyPath:@"center.y"
                 type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = [NSNumber numberWithFloat:-y];
        yAxis.maximumRelativeValue = [NSNumber numberWithFloat:y];
    }
    
    if (xAxis || yAxis)
    {
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        NSMutableArray *effects = [[NSMutableArray alloc] init];
        if (xAxis)
        {
            [effects addObject:xAxis];
        }
        
        if (yAxis)
        {
            [effects addObject:yAxis];
        }
        group.motionEffects = effects;
        [self addMotionEffect:group];
        
        return group;
    }
    return nil;
}

- (void)adjustIntegralFrame
{
    self.frame = CGRectIntegral(self.frame);
}
@end
