//
//  YMVideoRecordController.h
//  Daiba
//
//  Created by YouMeng on 2017/7/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMVideoRecordController : UIViewController

// 返回 图片
@property(nonatomic,copy)void(^imgBlock)(UIImage* image);
@end
