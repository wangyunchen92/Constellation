//
//  BaseViewController.h
//  CloudPush
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//添加点击手势
- (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector;
@end
