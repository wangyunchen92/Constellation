//
//  YMMeIconCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface YMMeIconCell : UITableViewCell

//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
//改变图像
@property(nonatomic,copy)void(^changeIconBlock)();

//用户模型
@property(nonatomic,copy)UserModel* usrModel;


//设置头像
//-(instancetype)shareCellWithChangeIconBlock:(void(^)())changeIconBlock;
@end
