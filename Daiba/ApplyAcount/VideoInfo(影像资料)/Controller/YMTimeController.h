//
//  YMTimeController.h
//  Daiba
//
//  Created by YouMeng on 2017/8/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTimeController : UIViewController

@property(nonatomic,copy)void(^startRecordBlock)(BOOL isStart);
@end
