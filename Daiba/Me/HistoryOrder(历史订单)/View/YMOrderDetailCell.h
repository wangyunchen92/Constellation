//
//  YMOrderDetailCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMOrderModel.h"

@interface YMOrderDetailCell : UITableViewCell

@property(nonatomic,copy)void(^contactBlock)();

@property(nonatomic,strong)YMOrderModel* orderModel;



+(instancetype)shareCellWithContactBlock:(void(^)())contactBlock;

@end
