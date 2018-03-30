//
//  FMManage.h
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMManage : NSObject
+ (FMManage *)sharedInstance;


- (NSMutableArray *)findAllConstellationDetail;
@end
