//
//  AVCaptureViewController.h
//  实时视频Demo
//
//  Created by zhongfeng1 on 2017/2/16.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"

@interface AVCaptureViewController : UIViewController

//传递block
@property(nonatomic,copy)void(^idInfoBlock)(IDInfo* infoModel,UIImage* image,BOOL isFront);

//是否是正面头像
@property(nonatomic,assign)BOOL isFront;

@end

