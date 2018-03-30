//
//  ConstellaDetailModel.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "ConstellaDetailModel.h"

@implementation ConstellaDetailModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _consteID = @"";
        _consteName = @"";
        _consteDate = @"";
        _consteSpec = @"";// 特点
        _consteSxsx = @"";// 四象属性
        _consteGW = @"";//宫位
        _consteYysx = @"";// 阴阳属性
        _consteTz = @"";// 特征
        _consteZgxx = @"";//主管行星
        _consteXyys = @"";//幸运颜色
        _consteJxsw = @"";//吉祥事物
        _consteXyHm = @"";//幸运号码
        _consteKyjs = @"";//开运金属
        _consteAdvantage = @"";// 基本特质
        _consteJttz = @"";// 具体特质
        _consteXsfg = @"";// 行事风格
        _consteGxmd = @"";// 个性盲点
        _consteSummary = @"";// 总结
    }
    return self;
}

- (void)getModelForSqlit:(FMResultSet *)result {
    self.consteID = [result stringForColumn:@"_id"];
    self.consteName = [result stringForColumn:@"name"];
    self.consteDate = [result stringForColumn:@"dateduring"];
    self.consteSpec = [result stringForColumn:@"xztd"];
    self.consteSxsx = [result stringForColumn:@"sxsx"];
    self.consteGW = [result stringForColumn:@"zggw"];
    self.consteYysx = [result stringForColumn:@"yysx"];
    self.consteTz = [result stringForColumn:@"zdtz"];
    self.consteZgxx = [result stringForColumn:@"zgxx"];
    self.consteXyys = [result stringForColumn:@"xyys"];
    self.consteJxsw = [result stringForColumn:@"jxsw"];
    self.consteXyHm = [result stringForColumn:@"xyhm"];
    self.consteKyjs = [result stringForColumn:@"kyjs"];
    self.consteAdvantage = [result stringForColumn:@"advantage"];
    self.consteJttz = [result stringForColumn:@"jttz"];
    self.consteXsfg = [result stringForColumn:@"xsfg"];
    self.consteGxmd = [result stringForColumn:@"gxmd"];
    self.consteSummary = [result stringForColumn:@"summary"];
}
@end
