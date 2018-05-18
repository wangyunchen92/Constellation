//
//  PostWebViewController.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/3/5.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>
// 有请求的WebView
@interface PostWebViewController : BaseViewController
//网页链接 -- 标题
@property(nonatomic,copy)NSString* titleStr;
@property(nonatomic,copy)NSString* urlStr;
@end
