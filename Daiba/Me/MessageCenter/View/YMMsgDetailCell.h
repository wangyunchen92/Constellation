//
//  YMMsgDetailCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMMsgModel.h"



@interface YMMsgDetailCell : UITableViewCell

@property(nonatomic,strong)YMMsgModel* model;
//创建实例
+(instancetype)shareCell;
@end
