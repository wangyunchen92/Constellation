//
//  UIView+Addition.m
//  UIViewDemo4
//
//  Created by Hailong.wang on 15/7/29.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)
//宽
- (CGFloat)width {
    return self.frame.size.width;
}

//高
- (CGFloat)height {
    return self.frame.size.height;
}

//上
- (CGFloat)top {
    return self.frame.origin.y;
}

//下
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

//左
- (CGFloat)left {
    return self.frame.origin.x;
}

//右
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

//设置宽
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

//设置高
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//设置x
- (void)setXOffset:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

//设置y
- (void)setYOffset:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//设置Origin
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

//设置size
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

//设置x
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x {
    return self.frame.origin.x;
}
-(CGFloat)y {
    return self.frame.origin.y;
}

//设置y
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
//事件从应用程序开始，按照从上到下的顺序（UIApplication -> UIWindow -> rootViewController -> ...）一级一级传递，并且系统在寻找最适合处理事件的控件时，是从后往前遍历子控件的
//判断自己能否接受触摸事件，如果不能，返回nil
//判断触摸点是否在自己身上，如果不能，返回nil
//从后往前遍历子控件，重复上面的步骤，如果没有适合的子控件，返回自己
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //如果不能接收触摸事件，直接返回nil
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha < 0.01) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    int count = (int)self.subviews.count;
    //从后往前遍历子控件，如果子控件能接收到触摸事件，并且触摸点在子控件上，返回子控件，否则，返回self
    for (int i = count - 1; i >= 0; i --) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *view = [childView hitTest:childPoint withEvent:event];
        if (view) {
            return view;
        }
    }
    return self;
}


/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}

//毛玻璃效果  Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}
@end
