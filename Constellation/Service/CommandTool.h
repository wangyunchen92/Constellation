//
//  CommandTool.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/1/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandTool : NSObject
@property (nonatomic, strong)RACCommand *command_haveNewVersion; // 检查新版本

@property (nonatomic, strong)RACCommand *command_isTest; //  是否为审核状态

@property (nonatomic, strong)RACCommand *command_channel; // 开关接口


@end
