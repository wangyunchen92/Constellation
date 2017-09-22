//
//  IdCardInfo.h
//  RecognizeIdCard
//
//  Created by 吕同生 on 16/12/16.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdCardInfo : NSObject

@property (nonatomic) int type; //1:正面  2:反面
@property (retain, nonatomic) NSString *code; //身份证号
@property (retain, nonatomic) NSString *name; //姓名
@property (retain, nonatomic) NSString *gender; //性别
@property (retain, nonatomic) NSString *nation; //民族
@property (retain, nonatomic) NSString *address; //地址
@property (retain, nonatomic) NSString *issue; //签发机关
@property (retain, nonatomic) NSString *valid; //有效期

-(NSString *)stringWithIdInfo;
-(BOOL)isOK;

@end
