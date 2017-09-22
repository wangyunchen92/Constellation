//
//  FaceIDNetAPI.m
//  MegLiveDemo
//
//  Created by megvii on 16/6/13.
//  Copyright © megvii. All rights reserved.
//

#import "FaceIDNetAPI.h"

@implementation FaceIDNetAPI

/*
 单实例
 */
static  FaceIDNetAPI* _sharedInstance;

static dispatch_queue_t serialQueue;
//单例对象
+ (FaceIDNetAPI *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FaceIDNetAPI alloc] init];
    });
    return _sharedInstance;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        serialQueue = dispatch_queue_create("com.youmeng.FaceIDNetAPI.SerialQueue", NULL);
        if (_sharedInstance == nil) {
            _sharedInstance = [[super allocWithZone:zone]init];
        }
    });
    return _sharedInstance;
}


- (void)verifyFaceImages:(NSDictionary *)images userCardName:(NSString *)name userCardID:(NSString *)cardId delta:(NSString *)delta userCardImg:(UIImage *)cardImg  finish:(void (^)(id task, id responseObject, NSError *error))finish{
    
    NSString *hostapi = @"https://api.faceid.com/faceid/v1/verify";
    
    NSDictionary *dic = @{@"api_key":kFaceAppKey,
                          @"api_secret":kFaceSecrect,
                          @"name":name,
                          @"idcard":cardId,
                          @"delta":delta};
    
    [[AFHTTPSessionManager manager] POST:hostapi
                              parameters:dic
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   if (images) {
                       NSArray *allKeys = [images allKeys];
                       [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           NSString *imageKey = obj;
                           NSData *imageData = [images valueForKey:imageKey];
                           
                           [formData appendPartWithFileData:imageData name:imageKey fileName:imageKey mimeType:@"image/jpeg"];
                       }];
                   }
                   if (cardImg) {
                       NSData *cardData = UIImageJPEGRepresentation(cardImg, 1.0);
                       [formData appendPartWithFileData:cardData name:@"image_idcard" fileName:@"image_idcard" mimeType:@"image/jpeg"];
                   }
               }
                                progress:^(NSProgress * _Nonnull uploadProgress) {}
                                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                                     if (finish)
                                         finish(operation, responseObject,nil);
                                 }
                                 failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                     DDLog(@"err -- %@",error);
                                     if (finish)
                                         finish(operation, nil,error);
                                 }];
}

- (void)verifyV2FaceImages:(NSDictionary *)images
              userCardName:(NSString *)name
                userCardID:(NSString *)cardId
             userCardImage:(UIImage *)cardImage
                     delta:(NSString *)delta
                    finish:(void (^)(id task, id responseObject, NSError *error))finish{
 
    NSDictionary *parameters = @{@"api_key":kFaceAppKey,
                                 @"api_secret":kFaceSecrect,
                                 @"comparison_type":@"1",
                                 @"face_image_type":@"meglive",
                                 @"idcard_name":name,
                                 @"idcard_number":cardId,
                                 @"delta":delta};
    
    NSString *hostapi = @"https://api.megvii.com/faceid/v2/verify";
    
    [[AFHTTPSessionManager manager] POST:hostapi
                              parameters:parameters
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   if (images) {
                       NSArray *allKeys = [images allKeys];
                       [allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           NSString *imageKey = obj;
                           NSData *imageData = [images valueForKey:imageKey];
                           
                           [formData appendPartWithFileData:imageData name:imageKey fileName:imageKey mimeType:@"image/jpeg"];
                       }];
                   }
                   if (cardImage) {
                       NSData *cardData = UIImageJPEGRepresentation(cardImage, 1.0);
                       [formData appendPartWithFileData:cardData name:@"image_ref1" fileName:@"image_ref1" mimeType:@"image/jpeg"];
                   }
               }
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                    
                                   // DDLog(@"uploadProgress == %@",uploadProgress);
                                    
                                }
                                 success:^(NSURLSessionDataTask *operation, id responseObject) {
                                 DDLog(@"responseObject == %@",responseObject);
                                     if (finish)
                                         finish(operation, responseObject,nil);
                                 }
                                 failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                     // DDLog(@"error == %@",error);
                                     NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                                     if (data != nil) {
                                        id errInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                      //   NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       //  NSLog(@"error--%@", str); //就可以获取到错误时返回的body信息。
                                         if (finish)
                                             finish(operation,errInfo,error);

                                     }
                                 }];
    
}
 

@end
