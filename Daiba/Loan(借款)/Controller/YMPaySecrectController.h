//
//  YMPaySecrectController.h
//  Daiba
//
//  Created by YouMeng on 2017/8/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface YMPaySecrectController : BaseViewController

@property(nonatomic,copy)void(^refreshStateBlock)(BOOL isSet,NSString* password);
@end
