//
//  IdCardModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdCardModel : NSObject

//身份证 正反面 照片
@property(nonatomic,copy)NSString*  card_imgA;
@property(nonatomic,copy)NSString*  card_imgB;
//姓名 身份证号
@property(nonatomic,copy)NSString*  real_name;
@property(nonatomic,copy)NSString*  card_number;


@end
