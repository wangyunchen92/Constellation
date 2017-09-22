//
//  BaseModel.m
//  挑食
//
//  Created by duyong_july on 16/3/6.
//  Copyright © 2016年 挑食科技. All rights reserved.
//

#import "BaseModel.h"
#import "NSString+Catogory.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
//去除null
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == nil ||
        [value isKindOfClass:[NSNull class]] ||
        [value isEqual:[NSNull null]]) {
        [super setValue:@"" forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}


@end
