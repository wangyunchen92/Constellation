//
//  HomeViewModel.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HomeViewModel.h"
#import "FMManage.h"

@implementation HomeViewModel


- (void)initSigin {
      self.dataArray = [[FMManage sharedInstance] findAllConstellationDetail];
    
}

@end
