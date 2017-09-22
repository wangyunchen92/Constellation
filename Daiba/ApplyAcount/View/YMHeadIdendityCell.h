//
//  YMHeadIdendityCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface YMHeadIdendityCell : UITableViewCell



@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);

@property(nonatomic,strong)PhotoModel* photoModel;

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock;
@end
