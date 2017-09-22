//
//  YMVideoInfoController.h
//  Daiba
//
//  Created by YouMeng on 2017/7/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMVideoInfoController : UIViewController

@property(nonatomic,assign)BOOL isShowNext;
@property(nonatomic,assign)BOOL isModify;

@property(nonatomic,copy)void(^refreshBlock)();

@end
