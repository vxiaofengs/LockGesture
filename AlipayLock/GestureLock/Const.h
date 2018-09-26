//
//  Const.h
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define LineColor   rgba(34,178,246,1)
#define CircleColorSelected    rgba(34,178,246,1)
#define ArrowColor    rgba(34,178,246,1)
#define CircleColorNotSelected rgba(1,1,1,1)

#define InnerCircleRadius 10

extern NSString* const kPassword;


@property(nonatomic,retain)NSString* passWord;




+(instancetype)sharedConst;
@end
