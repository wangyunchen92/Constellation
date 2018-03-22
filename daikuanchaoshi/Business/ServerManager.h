//
//  ServerManager.h
//  ColorfulFund
//
//  Created by Madis on 16/8/15.
//  Copyright © 2016年 zritc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelResponse : NSObject

@property (nonatomic        ) BOOL         isSuccuss;
@property (nonatomic, copy  ) NSString     *optype;         // 接口
@property (nonatomic, copy  ) NSString     *requestRid;     // 请求次数
@property (nonatomic, copy  ) NSString     *responseSid;    // 返回session
@property (nonatomic, copy  ) NSString     *responseCode;   // 返回状态码
@property (nonatomic, copy  ) NSString     *responseDesc;   // 描述
@property (nonatomic, strong) NSDictionary *userData;

@end

/**
 *  网络请求操作回调函数
 *
 *  @param isSucessed 请求是否成功
 *  @param iParam     请求的输入参数
 *  @param oParam     请求的输出参数（当请求失败时为nil）
 *  @param eMsg       请求错误信息（当请求成功时为nil）
 */
typedef void (^RequestCallBack)(BOOL isSucessed,id iParam, id oParam, NSString *eMsg);

@interface ServerManager : NSObject

+ (ServerManager *)share;

/*!
 *
 *  post请求
 *
 *  @param url             url地址
 *  @param params          请求参数
 *  @param callBack        网络回调
 */
- (void)request_postWithURL:(NSString *)url
                     params:(NSDictionary *)params
                   callBack:(RequestCallBack)callBack;


/*!
 *
 *  get请求
 *
 *  @param url             url地址
 *  @param params          请求参数
 *  @param callBack        网络回调
 */
- (void)request_getWithURL:(NSString *)url
                     params:(NSDictionary *)params
                  callBack:(RequestCallBack)callBack;


/*!
 *
 *  请求json文件
 *
 *  @param baseUrl         url初始地址
 *  @param method          后缀地址
 *  @param callBack        网络回调
 */

- (void)request_jsonWithURL:(NSString *)baseUrl
                     method:(NSString *)method
                   callBack:(void (^)(BOOL isSuccess,NSDictionary *responseDict))callBack;


/*!
 *
 *  请求FamilyScene文件
 *
 *  @param baseUrl         url初始地址
 *  @param callBack        网络回调
 */
- (void)request_familySceneStringWithURL:(NSString *)baseUrl
                   callBack:(void (^)(BOOL isSuccess,NSString *responseString))callBack;
/*!
 *
 *  上传图片
 *
 *  @param fileData 文件数据
 *  @param callBack 网络回调
 */
- (void)uploadImage:(NSData *)fileData
            pathKey:(NSString *)pathKey
           callBack:(RequestCallBack)callBack;

@end
