//
//  AddressModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

//单位
@property(nonatomic,copy)NSString*  company;
@property(nonatomic,copy)NSString*  company_phone;
//居住
@property(nonatomic,copy)NSString*  live_adress;
@property(nonatomic,copy)NSString*  live_area;
//工作
@property(nonatomic,copy)NSString*  work_adress;
@property(nonatomic,copy)NSString*  work_area;




@end
