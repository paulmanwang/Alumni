//
//  UIViewx.h
//  MemoLite
//
//  Created by czh0766 on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (X)

+(id) viewWithNib:(NSString*)nib owner:(id)owner;

-(void) offset:(CGPoint)point;

-(void) setPosition:(CGPoint)position;

-(void) setSize:(CGSize)size;

-(CGPoint) postion;

-(CGSize) size;

-(CGPoint) boundsCenter;

-(float) left;

-(float) top;

-(float) right;

-(float) bottom;

-(float) width;

-(float) height;

-(void) setWidth:(float)width;

-(void) setHeight:(float)height;

-(void) setLeft:(float)lef;

-(void) setRight:(float)right;

-(void) setTop:(float)top;

-(void) setBottom:(float)bottom;

-(void) clearSubviews;

-(void) replaceView:(UIView*)view atIndex:(int)index;

-(UIView*) viewAtIndex:(int)index;

-(void) removeViewAtIndex:(int)index;

-(void) transitionToAddSubview:(UIView*)view duration:(NSTimeInterval)duration;

-(void) transitionToRemoveFromSuperview:(NSTimeInterval)duration;

-(BOOL) pointInsideFrame:(CGPoint)location;

-(NSUInteger) indexOfView:(UIView*)view;

// 向上层寻找父View直到条件匹配, proc里面返回YES代表匹配成功, 匹配成功后循环停止
-(UIView*) superviewByCompareProc:(BOOL (^)(UIView* viewToCheck))compareLogic;

// 仅遍历自己的子View直到条件匹配, proc里面返回YES代表匹配成功, 匹配成功后循环停止
-(UIView*) subviewByCompareProc:(BOOL (^)(UIView* viewToCheck))compareLogic;

// 递归遍历所有子View(整个树), proc里面返回YES代表匹配成功, 匹配成功后循环停止
-(UIView*) traverseSubviewsWithProc:(BOOL (^)(UIView* viewToCheck))traverseProc;

-(UITapGestureRecognizer*) addTapGestureRecognizer:(id)target forAction:(SEL)action;

-(UILongPressGestureRecognizer*) addLongPressGestureRecognizer:(id)target forAction:(SEL)action;

- (NSString *)recursiveDescription;

-(void) layoutSubviewsInCenter;

-(void) applyBarShadowWithOffset:(CGSize)offset
                         opacity:(CGFloat)opacity
                           color:(UIColor*)color
                    shadowRadius:(CGFloat)shadowRadius
                 shouldRasterize:(BOOL)shouldRasterize;
-(void) applyBarShadowWithOffset:(CGSize)offset
                         opacity:(CGFloat)opacity
                           color:(UIColor*)color
                    shadowRadius:(CGFloat)shadowRadius;
-(void) applyBarShadowCopyFromView:(UIView*)view;
// 如果用上面的API应用了阴影,则要解决动画冲突则需要调用这个并bounds改变之后都需要调用一次
-(void) refreshShadowPathAccordingToBounds;
-(void) refreshShadowAccordingToRect:(CGRect)rect;

// 把View切成四个角都是圆角的矩形(切出来的形状大小随着view而变)
-(void) applyRoundCornerWithRadius:(CGFloat)radius
                     masksToBounds:(BOOL)masksToBounds;

// 对View指定一个区域切出一块可指定圆角个数的矩形(注意:切出来的形状大小固定)
// 若想使剪出来的区域动态改变,需要在layoutSubviews或相关函数里更新rect重新调用
-(void) maskWithRoundCorners:(UIRectCorner)corners
                 widthRadius:(CGFloat)radius
                     forRect:(CGRect)rect
                 borderColor:(UIColor*)borderColor
                 borderWidth:(CGFloat)borderWidth
               masksToBounds:(BOOL)masksToBounds;

// 在View中剪出一个圆形
-(void) applyRoundMaskWithRoundCenter:(CGPoint)center
                               radius:(CGFloat)radius;

// 根据图片形状来切View
-(void) maskWithImages:(NSArray*)arrayOfUIImage;

-(void)applyFadeAnimationWithKey:(NSString*)key duration:(CGFloat)duration;
-(void)applyFadeAnimationWithKey:(NSString*)key;

// for IOS4 using colorWithPatternImage black bk problem
-(void)fixColorWithPatternImageForBackgroundColor;

// direction is either "L" "R" "T" "B" representing left right top bottom
// when this method is called, self.hidden will be NO
// and after animation orgView.hidden will be YES
-(void)doPushAnimationFromDirection:(NSString*)direction
                       originalView:(UIView*)orgView
                           duration:(NSTimeInterval)duration
                    beforeAnimation:(dispatch_block_t)beforeAnimation
                         completion:(void (^)(BOOL finished))completion;

-(void)doShakeAnimationWithOffset:(CGSize)offset
                      repeatCount:(CGFloat)repeatCount
              durationForOneShake:(NSTimeInterval)durationForOneShake;

// 给view赋予“层”手势效果 （API在iOS7或以上的系统有效), 返回值类型 UIMotionEffectGroup
// 这个效果不推荐广泛应用，可以用在自定义的浮层和Alert上面，自定义的iPad的FormSheet不要用这个东西
-(id)addMotionEffectWithPositiveX:(CGFloat)positiveX
                        negativeX:(CGFloat)negativeX
                        positiveY:(CGFloat)positiveY
                        negativeY:(CGFloat)negativeY;
-(id)addMotionEffectWithXTilt:(CGFloat)x
                        YTilt:(CGFloat)y;

// 用于辅助测试: 用颜色填充各个子view,测试各自的区域位置
-(void)testSubviewRectWithColors;

- (void)adjustIntegralFrame;

@end

// Nib容器加载器
#define X_DEF_VIEW_LOADER_FOR_VIEWCLASS(viewClass,loaderClass) \
@interface loaderClass : UIView \
@property (strong, nonatomic) viewClass* view; \
@end

// Nib容器加载器的实现, 容器加载器只在nib加载的时候作定位作用, 其真实作用相当于Controller
#define X_IMPL_VIEW_LOADER_FOR_VIEWCLASS_WITHNIB(nibName,viewClass,loaderClass) \
@implementation loaderClass \
- (void)awakeFromNib { \
    self.view = [UIView viewWithNib:nibName owner:nil]; \
    self.view.frame = self.frame; \
    [self.superview addSubview:self.view]; \
    [self removeFromSuperview]; \
} \
@end

// Nib与类名同名的实现
#define X_IMPL_VIEW_LOADER_FOR_VIEWCLASS(viewClass,loaderClass) X_IMPL_VIEW_LOADER_FOR_VIEWCLASS_WITHNIB(NSStringFromClass([viewClass class]),viewClass,loaderClass)

// 子类继承时可用的方便初始化
#define XL_IMPL_VIEW_INTERNAL_INIT_METHODS \
- (id)init \
{ \
    self = [super init]; \
    if (self) { \
        [self _init]; \
    } \
    return self; \
} \
- (id)initWithCoder:(NSCoder *)aDecoder \
{ \
    self = [super initWithCoder:aDecoder]; \
    if (self) { \
        [self _init]; \
    } \
    return self; \
} \
- (id)initWithFrame:(CGRect)frame \
{ \
    self = [super initWithFrame:frame]; \
    if (self) { \
        [self _init]; \
    } \
    return self; \
}