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
@property (nonatomic, strong)RACSubject *subject_isRedPacket;
@property (nonatomic, strong)NSMutableArray *serverArray;
@property (nonatomic, strong)NSMutableArray *bannerArray;

@property (nonatomic, copy)void (^block_redPacket)(NSString *url,NSString *image);

@end
