//
//  AddressBookModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject


//同事 电话 姓名
@property(nonatomic,copy)NSString*  colleague_name;
@property(nonatomic,copy)NSString*  colleague_phone;
//家人 电话 姓名
@property(nonatomic,copy)NSString*  family_name;
@property(nonatomic,copy)NSString*  family_phone;
//朋友 姓名 电话
@property(nonatomic,copy)NSString*  friend_name;
@property(nonatomic,copy)NSString*  friend_phone;


@end
