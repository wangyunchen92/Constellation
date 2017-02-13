//
//  UIControl+RYButton.m
//  runtimedemo
//
//  Created by 王云晨 on 16/6/15.
//  Copyright © 2016年 王云晨. All rights reserved.
//

#import "UIControl+RYButton.h"
#import <objc/runtime.h>

static const char * RY_Node = "ry_height";

@implementation UIControl (RYButton)




-(void)setRy_Node:(Node *)ry_height
{
    objc_setAssociatedObject(self, RY_Node, ry_height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(Node *)ry_Node{
    return objc_getAssociatedObject(self, RY_Node);
}





@end
