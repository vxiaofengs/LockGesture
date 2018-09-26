//
//  ItemView.m
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import "ItemView.h"
#import "Const.h"
@implementation ItemView

-(instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //旋转
    [self rotateLayer:ctx rect:rect];
    //画外圆
    [self drawCircle:ctx rect:rect];
    if (_isSelected) {
        //画内圆
        [self drawInnerCircle:ctx rect:rect];
        //画三角
        [self drawArrow:ctx rect:rect];
    }
}

- (void)rotateLayer:(CGContextRef)ctx rect:(CGRect)rect
{
    if (_angle==0) {
        return;
    }
    CGFloat translateXY = rect.size.width * .5f;
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    CGContextRotateCTM(ctx, _angle);
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}


- (void)drawInnerCircle:(CGContextRef)ctx rect:(CGRect)rect
{
    [CircleColorSelected setFill];
    CGFloat xPositon=(rect.size.width-InnerCircleRadius*2)/2;
    CGContextAddEllipseInRect(ctx, CGRectMake(xPositon, xPositon, InnerCircleRadius*2, InnerCircleRadius*2));
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)drawCircle:(CGContextRef)ctx rect:(CGRect)rect
{
    [_isSelected?CircleColorSelected:CircleColorNotSelected setStroke];
    CGContextAddEllipseInRect(ctx, CGRectMake(0.5, 0.5, rect.size.width-1, rect.size.width-1));
    CGContextStrokePath(ctx);
}

- (void)drawArrow:(CGContextRef)ctx rect:(CGRect)rect
{
    if (_isNotTheLast) {
        CGPoint center=CGPointMake(rect.size.width/2, rect.size.height/2);
        [ArrowColor setFill];
        CGContextMoveToPoint(ctx, center.x-3+20, center.y-5);
        CGContextAddLineToPoint(ctx, center.x-3+20, center.y+5);
        CGContextAddLineToPoint(ctx, center.x+3+20, center.y);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
}


-(void)setAngle:(CGFloat)angle
{
    _angle=angle;
    [self setNeedsDisplay];
}

@end
