//
//  ConstellaDetailModel.h
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface ConstellaDetailModel : NSObject

@property (nonatomic, copy)NSString *consteID;
@property (nonatomic, copy)NSString *consteName;
@property (nonatomic, copy)NSString *consteDate;
@property (nonatomic, copy)NSString *consteSpec;// 特点
@property (nonatomic, copy)NSString *consteSxsx;// 四象属性
@property (nonatomic, copy)NSString *consteGW;//宫位
@property (nonatomic, copy)NSString *consteYysx;// 阴阳属性
@property (nonatomic, copy)NSString *consteTz;// 特征
@property (nonatomic, copy)NSString *consteZgxx;//主管行星
@property (nonatomic, copy)NSString *consteXyys;//幸运颜色
@property (nonatomic, copy)NSString *consteJxsw;//吉祥事物
@property (nonatomic, copy)NSString *consteXyHm;//幸运号码
@property (nonatomic, copy)NSString *consteKyjs;//开运金属
@property (nonatomic, copy)NSString *consteAdvantage;// 基本特质
@property (nonatomic, copy)NSString *consteJttz;// 具体特质
@property (nonatomic, copy)NSString *consteXsfg;// 行事风格
@property (nonatomic, copy)NSString *consteGxmd;// 个性盲点
@property (nonatomic, copy)NSString *consteSummary;// 总结
- (void)getModelForSqlit:(FMResultSet *)result;
@end
