//
//  HomeViewModel.h
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : BaseViewModel
@property (nonatomic, strong)ConstellaDetailModel *model;
@property (nonatomic, strong)NSMutableArray *serverArray;


@end
