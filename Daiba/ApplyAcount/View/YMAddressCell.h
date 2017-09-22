//
//  YMAddressCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface YMAddressCell : UITableViewCell

@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);
//居住地址
@property (weak, nonatomic) IBOutlet UILabel *homeAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeDetailLabel;
//工作地址
@property (weak, nonatomic) IBOutlet UILabel *workAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *workDetailLabel;
//单位地址
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *comTelLabel;

//修改按钮
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;


@property(nonatomic,strong)AddressModel* addrsModel;

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock;

@end
