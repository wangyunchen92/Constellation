//
//  HomeBoardViewController.h
//  Constellation
//
//  Created by Sj03 on 2018/3/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WYCPagController/WMPageController.h>

@interface HomeBoardViewController : WMPageController

@property (nonatomic, assign)CGFloat reloadHeight;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end
