//
//  YMWebViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "YMWebProgressLayer.h"

@interface YMWebViewController : BaseViewController


@property(nonatomic,copy)void(^agreeBlock)(NSString* isAgree);

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
//网页链接
@property(nonatomic,copy)NSString* urlStr;
//是否参数加密
@property(nonatomic,assign)BOOL isSecret;

@property(nonatomic,assign)BOOL isNext;

//类型id
@property(nonatomic,copy)NSString* typeId;
@end
