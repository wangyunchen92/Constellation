//
//  YMApplyMainController.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMApplyMainController : BaseViewController


@property(nonatomic,assign)BOOL isNext;

//被拒绝的步骤
@property(nonatomic,copy)NSString* checkStep;
@end
