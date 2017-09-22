//
//  UserDefaults.h
//  Test
//
//  Created by 吕同生 on 16/12/14.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (BOOL)usingVerify;

+ (void)setUsingVerify:(BOOL)isVerify;

@end
