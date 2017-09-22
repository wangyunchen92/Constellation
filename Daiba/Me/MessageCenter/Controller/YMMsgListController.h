//
//  YMMsgListController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMMsgListController : BaseViewController

//消息推送进来的
@property(nonatomic,assign)BOOL isMsgPushed;

@property(nonatomic,copy)void(^refreshBlock)(NSString* msgNum);
@end
