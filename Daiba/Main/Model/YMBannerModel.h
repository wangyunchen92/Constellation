//
//  YMBannerModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBannerModel : NSObject

@property(nonatomic,copy)NSString* add_time;

@property(nonatomic,copy)NSString* id;
//轮播图片路径
@property(nonatomic,copy)NSString* banner_path;

//轮播图片路径
@property(nonatomic,copy)NSString* sort;

//图片链接
@property(nonatomic,copy)NSString* img_path;


@end
