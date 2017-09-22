//
//  YMIdentityCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdCardModel.h"

@interface YMIdentityCell : UITableViewCell

@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);

//身份证icon
@property (weak, nonatomic) IBOutlet UIImageView *idImgView;
//是否 设置好 icon
@property (weak, nonatomic) IBOutlet UIImageView *idSureImgView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//身份证号
@property (weak, nonatomic) IBOutlet UILabel *idNumLabel;

//修改btn
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;


@property(nonatomic,strong)IdCardModel* idcardModel;

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock;



@end
