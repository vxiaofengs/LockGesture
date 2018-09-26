//
//  GestureLockView.h
//  AlipayLock
//
//  Created by houji007 on 15/10/23.
//  Copyright © 2015年 houji007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GestureLockView : UIView
@property(nonatomic,copy)void(^unlockSuccess)();
- (void)reSetPassWord;
@end
