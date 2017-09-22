//
//  YMDataManager.h
//  Daiba
//
//  Created by YouMeng on 2017/8/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMDataManager : NSObject

+ (YMDataManager *) sharedInstance;
//返回城市数组数据
+(NSArray*)addressArray;

//省
+(NSArray* )provinceArr;
//市
+(NSArray* )citiesArray;
//区
+(NSArray* )areasArray;



@end
