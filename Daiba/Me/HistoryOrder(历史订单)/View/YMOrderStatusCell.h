//
//  YMOrderStatusCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMOrderModel.h"

@interface YMOrderStatusCell : UITableViewCell

@property(nonatomic,strong)YMOrderModel* model;

+(instancetype)shareCell;

@end
