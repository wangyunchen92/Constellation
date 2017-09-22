//
//  YMMoneStatusCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"
#import "UserModel.h"


@interface YMMoneStatusCell : UITableViewCell

//借钱model   用户模型
@property(nonatomic,strong)BorrowModel* borrowModel;
@property(nonatomic,strong)UserModel*  usrModel;


+(instancetype)shareCell;
@end
