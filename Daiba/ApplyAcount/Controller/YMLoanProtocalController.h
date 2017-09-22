//
//  YMLoanProtocalController.h
//  Daiba
//
//  Created by YouMeng on 2017/8/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeadCell.h"


@interface YMLoanProtocalController : UIViewController


@property(nonatomic,strong)UIView* backgroundView;

@property(nonatomic,strong)void(^tapBlock)(SectionHeadCell *cell);
@end
