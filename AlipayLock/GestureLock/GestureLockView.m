//
//  GestureLockView.m
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import "GestureLockView.h"
#import "ItemView.h"
#import "Const.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define itemWidth 60*(SCREEN_WIDTH/320)
#define itemDis (SCREEN_WIDTH-3*itemWidth)/4
#define positionY  (SCREEN_HEIGHT-(itemWidth+itemDis)*4)/2

@interface GestureLockView ()
{
    NSMutableArray* _itemViewArr;
    NSMutableArray* _selectedItemViewArr;
    NSMutableString* _passWord;
    NSString* _password0;
    UILabel* _noticeLabel;
}

@end

@implementation GestureLockView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        _itemViewArr=[[NSMutableArray alloc]init];
        _selectedItemViewArr=[[NSMutableArray alloc]init];
        _passWord=[[NSMutableString alloc]init];
        
        _noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, positionY, SCREEN_WIDTH, 20)];
        _noticeLabel.text=@"滑动输入密码";
        _noticeLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_noticeLabel];
        
        
        for (int i=0; i<9; i++) {
            ItemView* item=[[ItemView alloc]init];
            [_itemViewArr addObject:item];
            item.tag=i;
            item.frame=CGRectMake((itemDis+itemWidth)*(i%3)+itemDis, (itemDis+itemWidth)*(i/3)+itemDis+positionY, itemWidth, itemWidth);
            [self addSubview:item];
        }
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    
    [_itemViewArr enumerateObjectsUsingBlock:^(ItemView* item, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextAddEllipseInRect(ctx, item.frame);
    }];
    
    CGContextEOClip(ctx);
    
    [_selectedItemViewArr enumerateObjectsUsingBlock:^(ItemView* item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==0) {
            CGContextMoveToPoint(ctx, item.center.x, item.center.y);
        }else{
            CGContextAddLineToPoint(ctx, item.center.x, item.center.y);
        }
    }];
    
    [LineColor setStroke];
    CGContextStrokePath(ctx);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _passWord=[[NSMutableString alloc]init];
    _noticeLabel.textColor=[UIColor blackColor];
    _noticeLabel.text=@"滑动输入密码";
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point=[touch locationInView:self];
    ItemView* itemView=[self getItemInLocation:point];
    if (!itemView) {
        return;
    }
    if ([_selectedItemViewArr containsObject:itemView]) {
        return;
    }
    [_selectedItemViewArr addObject:itemView];
    itemView.isSelected=YES;
    [_passWord appendFormat:@"%ld",(long)itemView.tag];
    
    [self getItemDirection];
    [itemView setNeedsDisplay];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_selectedItemViewArr.count<4) {
        _noticeLabel.textColor=[UIColor redColor];
        _noticeLabel.text=@"至少连接4个点";
        [self shakeAnimation];
    }else{
        NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
        NSString* savedPassword=[ud objectForKey:kPassword];
        
        if (savedPassword && ![savedPassword isEqualToString:@""]) {
            if ([savedPassword isEqualToString:_passWord]) {
                _noticeLabel.textColor=[UIColor blueColor];
                _noticeLabel.text=@"密码正确";
                _unlockSuccess();
            }else{
                _noticeLabel.textColor=[UIColor redColor];
                _noticeLabel.text=@"密码错误";
                [self shakeAnimation];
            }
        }else{
            if (!_password0) {
                _password0=_passWord;
                _noticeLabel.textColor=[UIColor blackColor];
                _noticeLabel.text=@"确认密码";
            }else{
                if ([_passWord isEqualToString:_password0]) {
                    [ud setObject:_password0 forKey:kPassword];
                    [ud synchronize];
                    _noticeLabel.textColor=[UIColor blueColor];
                    _noticeLabel.text=@"密码设置成功";
                }else{
                    _password0=nil;
                    _noticeLabel.textColor=[UIColor redColor];
                    _noticeLabel.text=@"两次密码不一致";
                    [self shakeAnimation];
                }
            }
        }
        [Const sharedConst].passWord=_passWord;
    }
    
    //清空操作
    for (ItemView *itemView in _itemViewArr) {
        itemView.isSelected = NO;
        itemView.isNotTheLast = NO;
        itemView.angle = 0;
    }
    [_selectedItemViewArr removeAllObjects];
    [self setNeedsDisplay];
    _passWord=nil;
}

- (void)reSetPassWord
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)shakeAnimation
{
    CAKeyframeAnimation* shakeAni=[CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat s=-16;
    shakeAni.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    shakeAni.duration = .1f;
    
    //重复
    shakeAni.repeatCount =2;
    
    //移除
    shakeAni.removedOnCompletion = YES;
    [_noticeLabel.layer addAnimation:shakeAni forKey:@"shake"];
}

- (void)getItemDirection
{
    if(_selectedItemViewArr==nil || _selectedItemViewArr.count<=1) return;
    
    ItemView* lastItem=_selectedItemViewArr.lastObject;
    ItemView* last2Item=_selectedItemViewArr[_selectedItemViewArr.count-2];
    
    CGPoint lastCenter=lastItem.center;
    CGPoint last2Center=last2Item.center;
    CGFloat xiebian=sqrt((lastCenter.y-last2Center.y)*(lastCenter.y-last2Center.y)+(lastCenter.x-last2Center.x)*(lastCenter.x-last2Center.x));
    CGFloat angle=asin((lastCenter.y-last2Center.y)/xiebian);
    last2Item.isNotTheLast=YES;
    if ((lastCenter.x-last2Center.x)<=0) {
        last2Item.angle=M_PI-angle;
    }else{
        last2Item.angle=angle;
    }
}

- (ItemView*)getItemInLocation:(CGPoint)loc
{
    __block ItemView* itemView;
    [_itemViewArr enumerateObjectsUsingBlock:^(ItemView* item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(item.frame, loc)) {
            itemView=item;
            *stop=YES;
        }
    }];
    return itemView;
}

@end
