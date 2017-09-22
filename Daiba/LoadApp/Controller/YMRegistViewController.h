//
//  YMRegistViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMRegistViewController : BaseViewController

//注册的tag
@property(nonatomic,assign)BOOL isPresent;

//刷新网页block
//@property(nonatomic,copy)void(^refreshWebBlock)();

@property(nonatomic,assign)NSInteger tag;
@end
