//
//  ConstellationModel.h
//  Constellation
//
//  Created by Sj03 on 2018/4/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstellationModel : NSObject
@property (nonatomic, copy)NSString *consteYunShi;
@property (nonatomic, copy)NSString *consteAiQing;
@property (nonatomic, copy)NSString *consteGongZuo;
@property (nonatomic, copy)NSString *consteCaiFu;
- (void)getDateForeServer:(NSDictionary *)dic;
@end

@interface ConstellaDayModel :ConstellationModel
@property (nonatomic, copy)NSString *summaryStar;
@property (nonatomic, copy)NSString *loveStar;
@property (nonatomic, copy)NSString *moneyStar;
@property (nonatomic, copy)NSString *workStar;
@property (nonatomic, copy)NSString *consteGrxz;
@property (nonatomic, copy)NSString *consteLuckNum;
@property (nonatomic, copy)NSString *consteLuckCol;
@property (nonatomic, copy)NSString *consteluckyTime;
@property (nonatomic, copy)NSString *consteDaynotice;
@end

@interface ConstellaWeakModel :ConstellaDayModel
@property (nonatomic, copy)NSString *consteLuckDay;
@end

@interface ConstellaMonthModel :ConstellaDayModel
@property (nonatomic, copy)NSString *consteYfxz; // 缘分星座
@end

@interface ConstellaYearModel : ConstellationModel
@property (nonatomic, copy)NSString *consteGeneral; // 综合指数
@property (nonatomic, copy)NSString *consteLove;
@property (nonatomic, copy)NSString *consteMoney;
@property (nonatomic, copy)NSString *consteWork; 

@end
