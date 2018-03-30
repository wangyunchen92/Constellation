//
//  BaseViewModel.h
//  Constellation
//
//  Created by Sj03 on 2018/3/26.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstellaDetailModel.h"

@interface BaseViewModel : NSObject
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)RACSubject *subject_getDate;
@property (nonatomic, strong)ConstellaDetailModel *model;
@property (nonatomic, copy)void (^block_reloadDate)(void);
- (void)initSigin;
@end
