//
//  YMHelpModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHelpModel : NSObject

@property(nonatomic,copy)NSString* name;
@property(nonatomic,strong)NSMutableArray* content;

@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* id;


@end
