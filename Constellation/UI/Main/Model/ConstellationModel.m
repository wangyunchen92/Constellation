//
//  ConstellationModel.m
//  Constellation
//
//  Created by Sj03 on 2018/4/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "ConstellationModel.h"

@implementation ConstellationModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _consteCaiFu = @"";
        _consteAiQing = @"";
        _consteGongZuo = @"";
        _consteYunShi = @"";
    }
    return self;
}

- (void)getDateForeServer:(NSDictionary *)dic {
    self.consteCaiFu = [dic stringForKey:@"money_txt"];
    self.consteAiQing = [dic stringForKey:@"love_txt"];
    self.consteYunShi = [dic stringForKey:@"general_txt"];
    self.consteGongZuo = [dic stringForKey:@"work_txt"];
}
@end

@implementation ConstellaDayModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _consteGrxz = @"";
        _consteLuckCol = @"";
        _consteLuckNum = @"";
        _consteDaynotice = @"";
        _consteluckyTime = @"";
        _summaryStar = @"1";
        _workStar = @"1";
        _moneyStar = @"1";
        _loveStar = @"1";
    }
    return self;
}

- (void)getDateForeServer:(NSDictionary *)dic {
    [super getDateForeServer:dic];
    self.consteGrxz = [dic stringForKey:@"grxz"];
    self.consteLuckCol = [dic stringForKey:@"lucky_color"];
    self.consteLuckNum = [dic stringForKey:@"lucky_num"];
    self.consteluckyTime = [dic stringForKey:@"lucky_time"];
    self.consteDaynotice = [dic stringForKey:@"day_notice"];
    self.summaryStar = [dic stringForKey:@"summary_star"];
    self.loveStar = [dic stringForKey:@"love_star"];
    self.moneyStar = [dic stringForKey:@"money_star"];
    self.workStar = [dic stringForKey:@"work_star"];
}
@end

@implementation ConstellaWeakModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _consteLuckDay = @"";
    }
    return self;
}
- (void)getDateForeServer:(NSDictionary *)dic {
    [super getDateForeServer:dic];
    self.consteLuckDay = [dic stringForKey:@"lucky_day"];

}

@end

@implementation ConstellaMonthModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _consteYfxz = @"";
    }
    return self;
}

- (void)getDateForeServer:(NSDictionary *)dic {
    [super getDateForeServer:dic];
    self.consteYfxz = [dic stringForKey:@"yfxz"];
    
}

@end

@implementation ConstellaYearModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _consteGeneral = @"";
        _consteLove = @"";
        _consteMoney = @"";
        _consteWork = @"";
    }
    return self;
}

- (void)getDateForeServer:(NSDictionary *)dic {
        [super getDateForeServer:dic];
    self.consteGeneral = [dic stringForKey:@"general_index"];
    self.consteLove =  [dic stringForKey:@"love_index"];
    self.consteMoney = [dic stringForKey:@"money_index"];
    self.consteWork = [dic stringForKey:@"work_index"];
    
}

@end
