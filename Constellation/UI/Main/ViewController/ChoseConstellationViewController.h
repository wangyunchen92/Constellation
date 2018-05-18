//
//  ChoseConstellationViewController.h
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "BaseViewController.h"

@interface ChoseConstellationViewController : BaseViewController
@property (nonatomic, copy)void (^block_sele)(NSInteger index);
@property (nonatomic, copy)void (^blocl_dismiss)(void);

@end
