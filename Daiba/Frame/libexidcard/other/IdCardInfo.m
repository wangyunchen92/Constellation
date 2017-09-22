//
//  IdCardInfo.m
//  RecognizeIdCard
//
//  Created by 吕同生 on 16/12/16.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import "IdCardInfo.h"

@implementation IdCardInfo

- (NSString *)stringWithIdInfo {
    return [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@",
            _code, _name, _gender, _nation, _address];
}

- (BOOL)isOK {
    if (_code !=nil && _name!=nil && _gender!=nil && _nation!=nil && _address!=nil)
    {
        if (_code.length>0 && _name.length >0 && _gender.length>0 && _nation.length>0 && _address.length>0)
        {
            return true;
        }
    }
    else if (_issue !=nil && _valid!=nil)
    {
        if (_issue.length>0 && _valid.length >0)
        {
            return true;
        }
    }
    return false;
}

@end
