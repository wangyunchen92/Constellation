//
//  CustomDetectViewController.h
//  MegLiveDemo
//
//  Created by megviio on 2017/5/26.
//  Copyright © megvii. All rights reserved.
//

#import <MGLivenessDetection/MGLiveDetectViewController.h>

@interface CustomDetectViewController : MGLiveDetectViewController


@property(nonatomic,copy)void(^refreshBlock)();

//是否 显示下一步
@property(nonatomic,assign)BOOL isShowNext;
//是否 修改
@property(nonatomic,assign)BOOL isModify;


@end
