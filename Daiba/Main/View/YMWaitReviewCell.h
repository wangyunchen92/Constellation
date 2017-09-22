//
//  YMWaitReviewCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/4.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMWaitReviewCell : UITableViewCell

@property(nonatomic,copy)void(^applyBlock)(UIButton* btn);

//审核状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

+(instancetype)shareCellWithApplyBlocl:(void (^)(UIButton* btn))applyBlock;
@end
