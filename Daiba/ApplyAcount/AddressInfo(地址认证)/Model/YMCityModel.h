//
//  YMCityModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCityModel : NSObject

@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* id;
//城市
@property(nonatomic,strong)NSArray* cityArr;
//区或县
@property(nonatomic,strong)NSArray* areaArr;
@end
