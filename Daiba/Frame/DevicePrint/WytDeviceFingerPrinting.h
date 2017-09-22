//
//  WytDeviceFingerPrinting.h
//  WytDeviceFingerPrinting
//
//  Created by baojun on 2017/9/12.
//  Copyright © 2017年 com.weiyantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WytDeviceFingerPrinting;

/**
 SDK初始化回调协议
 */
@protocol WytDeviceFingerPrintingDelegate <NSObject>

/**
 初始化成功
 */
- (void)onWytDFInitSuccess:(NSString *) tokenKey;

/**
 初始化失败
 
 @param resultCode 错误码
 @param resultDesc 错误描述
 */
- (void)onWytDFInitFailure:(NSString *) resultCode withDesc:(NSString *) resultDesc;
@end


/**
 上传通讯录回调协议
 */
@protocol WytDeviceFingerPrintingContactsDelegate <NSObject>

/**
 通讯录上传成功
 */
- (void)onWytDFContactsUploadSuccess:(NSString *) tokenKey;

/**
 通讯录上传失败
 
 @param resultCode 错误码
 @param resultDesc 错误描述
 */
- (void)onWytDFContactsUploadFailure:(NSString *) resultCode withDesc:(NSString *) resultDesc;
@end


@interface WytDeviceFingerPrinting : NSObject

/**
 单例类方法
 @return instancetype
 */
+ (instancetype)sharedWytDeviceFingerPrinting;


/**
 设置上传通讯录回调
 
 @param delegate 回调
 */
- (void)setWytDeviceFingerPrintingContactsDelegate:(id<WytDeviceFingerPrintingContactsDelegate>) delegate;


/**
 设置回调
 
 @param delegate 回调
 */
- (void)setWytDeviceFingerPrintingDelegate:(id<WytDeviceFingerPrintingDelegate>) delegate;


/**
 获取tokenkey
 
 @return tokenkey
 */
- (NSString *)getTokenKey;


/**
 提交定位信息 注：如果初始化 isGatherGps 为 NO ， 在指定页调用此方法
 */
- (void)commitLocaiton;

/**
 提交定位信息(使用一些第三方定位，定位成功后将经纬度信息提交给服务器)
 */
- (void)commitLocaitonWithLongitude:(double) longitude withLatitude:(double) latitude;

/**
 提交通讯录 注：如果初始化 isGatherContacts 为 NO ， 在指定页调用此方法
 */
- (void)commitContacts;


/**
 是否需要执行初始化(为了避免频繁调用初始化而添加的方法)
 
 @return YES:需要 NO:不需要
 */
- (BOOL)canInitWytSDK;

/**
 初始化入口方法
 
 @param params 初始化参数
 传入参数: NSDictionary
 1)partnerId: 合作方编码，必填
 2)isGatherGps: 是否采集gps，默认YES:采集 NO:不采集
 3)isGatherContacts:是否采集通讯录，默认NO：不采集， YES:采集
 4)isTestingEnv:是否对接测试环境，默认NO：生产环境, YES:测试环境
 5)isGatherSensorInfo:是否采集传感器信息,默认YES:采集 NO:不采集
 */
- (void)initWytDFSdkWithParams:(NSDictionary *) params;

@end
