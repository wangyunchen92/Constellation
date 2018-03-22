//
//  ServerManager.m
//  ColorfulFund
//
//  Created by Madis on 16/8/15.
//  Copyright © 2016年 zritc. All rights reserved.
//

#import "ServerManager.h"
#import "ToolUtil+PublicParam.h"

@implementation ModelResponse
- (id)init
{
    self = [super init];
    if (self){
        self.isSuccuss    = NO;
        self.optype       = @"";
        self.requestRid   = @"";
        self.responseSid  = @"";
        self.responseCode = @"";
        self.responseDesc = @"";
        self.userData     = [NSDictionary new];
    }
    return self;
}
@end

static ServerManager *_serverManager;

// NOTE:后端设置超时时间2分半
static NSInteger timeoutInterval = 150;
static NSString *DESKeyString = @"x`I0CyBqL3wA76r0LD;pbnQ3sj35fsWvS6vKy0VtSUtRDY=b4ndegx6Dt_]WQ8/`";

static NSInteger kURLErrorCannotFindHost = 1003;

@interface ServerManager ()
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
//- (NSDictionary *)publicParam;
@end

@implementation ServerManager

+ (ServerManager *)share
{
    //里面的代码永远都只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serverManager = [[self alloc] init];
        _serverManager.sessionManager = [AFHTTPSessionManager manager];
        _serverManager.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _serverManager.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
        _serverManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;

    });
    return _serverManager;
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];

    
    return securityPolicy;
}

- (void)request_postWithURL:(NSString *)url
                     params:(NSDictionary *)params
                   callBack:(RequestCallBack)callBack
{
    _serverManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:[ToolUtil publicParam]];
    [fullParams addEntriesFromDictionary:params];

    MSLog(@"当前请求的参数:\nurl:%@\nfullParams:%@",url,fullParams);
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if(reachabilityManager.networkReachabilityStatus <= AFNetworkReachabilityStatusNotReachable){
        ModelResponse *response = [[ModelResponse alloc] init];
        response.responseDesc = @"当前网络不可用";
        callBack(NO,fullParams,response,response.responseDesc);
        MSLog(@"当前网络不可用");
        return;
    }
    
    if(![ToolUtil isUrl:url]){
        MSLog(@"url地址不合法:%@",url);
        ModelResponse *response = [[ModelResponse alloc] init];
        response.responseDesc = @"当前url地址不合法";
        callBack(NO,fullParams,response,response.responseDesc);
        return;
    }
    
    @weakify(self);
    [_serverManager.sessionManager POST:url parameters:fullParams progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[ToolUtil formatResponseData:responseObject] options:NSJSONReadingMutableContainers error:nil];
        MSLog(@"Post\nurl:%@\nparams:%@\nresponseDict:%@",url,fullParams,responseDict);
        ModelResponse *response = [ServerManager parseStatus:responseDict];
        callBack(response.isSuccuss,fullParams,response,response.responseDesc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MSLog(@"Post\nurl:%@\nparams:%@\nerror.description:%@",url,fullParams,error.description);
        @strongify(self);
        NSDictionary *dict = [self defaultErrorDict:error];
        if (dict) {
            MSLog(@"Para Success Post\nurl:%@\nparams:%@\nresponseObject:%@",url,fullParams,dict);
            ModelResponse *response = [ServerManager parseStatus:dict];
            callBack(YES, fullParams, response,response.responseDesc);
        } else {
            MSLog(@"Para Failure Post\nurl:%@\nparams:%@\nerror.description:%@",url,fullParams,error.description);
            ModelResponse *response = [ServerManager parseError:error];
            callBack(NO, fullParams, response, @"请求失败");
        }
    }];
}


- (void)request_getWithURL:(NSString *)url
                     params:(NSDictionary *)params
                   callBack:(RequestCallBack)callBack
{
    _serverManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:[ToolUtil publicParam]];
    [fullParams addEntriesFromDictionary:params];
    
    MSLog(@"当前请求的参数:\nurl:%@\nfullParams:%@",url,fullParams);
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if(reachabilityManager.networkReachabilityStatus <= AFNetworkReachabilityStatusNotReachable){
        ModelResponse *response = [[ModelResponse alloc] init];
        response.responseDesc = @"当前网络不可用";
        callBack(NO,fullParams,response,response.responseDesc);
        MSLog(@"当前网络不可用");
        return;
    }
    
    if(![ToolUtil isUrl:url]){
        MSLog(@"url地址不合法:%@",url);
        ModelResponse *response = [[ModelResponse alloc] init];
        response.responseDesc = @"当前url地址不合法";
        callBack(NO,fullParams,response,response.responseDesc);
        return;
    }
    
    @weakify(self);
    [_serverManager.sessionManager GET:url parameters:fullParams progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[ToolUtil formatResponseData:responseObject] options:NSJSONReadingMutableContainers error:nil];
        MSLog(@"Get\nurl:%@\nparams:%@\nresponseDict:%@",url,fullParams,responseDict);
        ModelResponse *response = [ServerManager parseStatus:responseDict];
        callBack(response.isSuccuss,params,response,response.responseDesc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MSLog(@"Get\nurl:%@\nparams:%@\nerror.description:%@",url,fullParams,error.description);
        @strongify(self);
        NSString *errorString = @"";
        if (error.userInfo) {
            NSDictionary *dict = error.userInfo;
            errorString = [NSString stringWithFormat:@"NSDebugDescription:%@",dict[@"NSDebugDescription"]];
        }else{
            errorString = error.description;
        }
        [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                    message:[NSString stringWithFormat:@"url:%@\nparams:%@\nerror.description:%@",url,params,errorString]
                                   delegate:nil
                          cancelButtonTitle:@"好的"
                          otherButtonTitles:nil] show];
        NSDictionary *dict = [self defaultErrorDict:error];
        if (dict) {
            MSLog(@"Get\nurl:%@\nparams:%@\nresponseObject:%@",url,fullParams,dict);
            ModelResponse *response = [ServerManager parseStatus:dict];
            callBack(YES, params, response,response.responseDesc);
        } else {
            MSLog(@"Get\nurl:%@\nparams:%@\nerror.description:%@",url,fullParams,error.description);
            ModelResponse *response = [ServerManager parseError:error];
            callBack(NO, params, response, @"请求失败");
        }
    }];
}

- (void)request_jsonWithURL:(NSString *)baseUrl
                     method:(NSString *)method
                   callBack:(void (^)(BOOL isSuccess,NSDictionary *responseDict))callBack
{
    @weakify(self);
    //添加时间戳，以防有缓存导致数据错误
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSString *url = [NSString stringWithFormat:@"%@%@?timestamp=%@",baseUrl,method,timestamp];
    /*NSInternalInconsistencyException‘, reason: ‘Invalid parameter not satisfying: URLString‘
     parameters参数不建议拼接在URL地址后,parameters不能设置为nil
     详见(http://www.cnblogs.com/niit-soft-518/p/4012011.html)
     */
    if([ToolUtil isUrl:url]){
        _serverManager.sessionManager.requestSerializer.timeoutInterval = 10;
        [_serverManager.sessionManager GET:url parameters:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            responseObject = [self formattingJsonFromResponseString:[ToolUtil decryptUseDESWithTextData:responseObject key:DESKeyString]];
            MSLog(@"\nurl:%@\nresponseObject:%@",url,responseObject);
            callBack(YES,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MSLog(@"\nurl:%@\nerror.description:%@",url,error.description);
            callBack(NO,error);
        }];
    }
}

- (void)request_familySceneStringWithURL:(NSString *)baseUrl
                                callBack:(void (^)(BOOL isSuccess,NSString *responseString))callBack
{
    /*NSInternalInconsistencyException‘, reason: ‘Invalid parameter not satisfying: URLString‘
    parameters参数不建议拼接在URL地址后,parameters不能设置为nil
    详见(http://www.cnblogs.com/niit-soft-518/p/4012011.html)
     */
    _serverManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    if([ToolUtil isUrl:baseUrl]){
        [_serverManager.sessionManager GET:baseUrl parameters:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            MSLog(@"\nurl:%@\nresponseString:%@",baseUrl,responseString);
            callBack(YES,responseString);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MSLog(@"\nurl:%@\nerror.description:%@",baseUrl,error.description);
            callBack(NO,error.description);
        }];
    }
}
//上传图片
- (void)uploadImage:(NSData *)fileData
           pathKey:(NSString *)pathKey
           callBack:(RequestCallBack)callBack
{
//    _serverManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
//    NSDictionary *params = @{@"pathKey":pathKey};
////  @{@"filename":@"", @"category":@"html", @"path":@""};
//    NSMutableDictionary *fullParam = [NSMutableDictionary dictionaryWithDictionary:[ToolUtil publicParam]];
//    [fullParam addEntriesFromDictionary:params];
//    [_serverManager.sessionManager POST:[[INIT share] interfaceAddressFromKey:@"uploadFile"] parameters:fullParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:fileData name:@"file" fileName:@"fileName" mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        @strongify(self);
////        responseObject = [self formattingJsonFromResponseString:[ToolUtil decryptUseDESWithTextData:responseObject key:DESKeyString]];
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        MSLog(@"\nurl:%@\nparams:%@\nresponseDict:%@",[[INIT share] interfaceAddressFromKey:@"uploadFile"],fullParam,responseDict);
//        ModelResponse *response = [ServerManager parseStatus:responseDict];
//        callBack(response.isSuccuss, params, response,response.responseDesc);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        callBack(NO, params, error.userInfo, @"图片上传失败");
//    }];
}

// 处理response
+ (id)parseStatus:(NSDictionary *)responseData
{
    ModelResponse* response = [[ModelResponse alloc] init];
    // 设置默认值
    response.responseDesc = @"请求失败";
    if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
        NSString *sid = responseData[@"sid"];
        NSString *rid = [NSString stringWithFormat:@"%@", responseData[@"rid"]];
        NSString *msg = responseData[@"msg"];
        NSString *optype = responseData[@"optype"];
        NSString *code = [NSString stringWithFormat:@"%@", responseData[@"code"]];
        
        response.requestRid   = rid;
        response.responseSid  = sid;
        response.optype       = optype;
        response.responseCode = code;
        response.responseDesc = msg;
        response.userData     = responseData;
        
        if ([code isEqualToString:kRequestSuccessfulCode]) {
            response.isSuccuss = YES;
        }  else if(kURLErrorCannotFindHost == [code integerValue] || kCFURLErrorCannotFindHost == [code integerValue]) {
            response.isSuccuss = NO;
            response.responseDesc = @"当前网络不可用，请稍后重试";
        }else{
            response.isSuccuss = NO;
        }
    }
    return response;
}

+ (ModelResponse *)parseError:(NSError *)error
{
    ModelResponse* response = [[ModelResponse alloc] init];
    response.responseDesc = @"请求失败";
    if(error.localizedDescription){
        response.requestRid   = @"0";
        response.optype       = error.userInfo[NSURLErrorFailingURLStringErrorKey];
        response.responseCode = @"0";
        response.responseDesc = error.localizedDescription;
        if(error.code == kCFURLErrorCannotFindHost) {
            //Error Domain=NSURLErrorDomain Code=-1003 "未能找到使用指定主机名的服务器。"
            response.responseDesc = @"当前网络不可用，请稍后重试";
        }
        response.userData     = error.userInfo;
    }
    return response;
}

- (NSDictionary *)defaultErrorDict:(NSError *)error
{
    NSDictionary *dict = nil;
    NSDictionary *ui = error.userInfo;
    if (ui && [ui isKindOfClass:[NSDictionary class]]) {
        NSString *des = [ui objectForKey:@"NSLocalizedDescription"];
        NSRange ran405 = [des rangeOfString:@"405"];
        if (ran405.length > 0) {
            NSString *strData = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
            NSString *newResponseString = [ToolUtil formatResponseString:strData];
            dict = [NSJSONSerialization JSONObjectWithData:[ToolUtil formatResponseStringValid:newResponseString] options:NSJSONReadingMutableContainers error:nil];
            return dict;
        }
    }
    return dict;
}

- (NSDictionary *)formattingJsonFromResponseString:(NSString *)responseString
{
    if (responseString){
        return [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
}

@end
