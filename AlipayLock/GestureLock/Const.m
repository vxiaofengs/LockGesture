//
//  Const.m
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import "Const.h"
NSString* const kPassword=@"kPassword";

@implementation Const
+(instancetype)sharedConst
{
    static dispatch_once_t t;
    static Const* single;
    dispatch_once(&t, ^{
        single=[[Const alloc]init];
    });
    return single;
}
@end
