//
//  UserDefaults.m
//  Test
//
//  Created by 吕同生 on 16/12/14.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import "UserDefaults.h"

static NSString* USING_VERIFY_DEFAULTS_KEY = @"usingVerify";

@implementation UserDefaults

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults]
     registerDefaults: @{
                         USING_VERIFY_DEFAULTS_KEY : [NSNumber numberWithBool:YES],
                         }];
}

+ (BOOL)usingVerify {
    return [[NSUserDefaults standardUserDefaults] boolForKey:USING_VERIFY_DEFAULTS_KEY];
}

+ (void)setUsingVerify:(BOOL)isVerify {
    [[NSUserDefaults standardUserDefaults] setBool:isVerify forKey:USING_VERIFY_DEFAULTS_KEY];
}

@end
