
#import "JHCNetWorking.h"
#import "JHCNetServerConfig.h"


typedef NS_ENUM(NSUInteger, HTTP_METHOD) {
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
};

static JHCNetWorking * _shareInstance;

@interface JHCNetWorking ()

@property(nonatomic,strong) NSMutableArray<NSURLSessionTask *> *allTasks; //存储下载对象
@property(nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation JHCNetWorking

+ (instancetype)shareInstance
{
    if(_shareInstance == nil){
        _shareInstance = [[JHCNetWorking alloc] init];
        
        _shareInstance.manager = [AFHTTPSessionManager manager];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(_shareInstance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _shareInstance;
}


/**
 * GET请求 普通
 */
+ (URLSessionTask *)GET:(NSString *)urlStr
                 params:(NSDictionary * _Nullable)params
           timeInterval:(NSNumber * _Nullable)timeInterval
                success:(SuccessBlock)successBlock
                   fail:(FailBlock)failBlock
{
    [JHCNetWorkConfig shareInstance].requestType = [AFJSONRequestSerializer serializer];
    [JHCNetWorkConfig shareInstance].responseType = [AFHTTPResponseSerializer serializer];
    return [self GET:urlStr params:params timeInterval:timeInterval progressBlock:nil success:successBlock fail:failBlock];
}

/**
 * GET请求 特殊(获取下载进度)
 */
+ (URLSessionTask *)GET:(NSString *)urlStr
                 params:(NSDictionary * _Nullable)params
           timeInterval:(NSNumber * _Nullable)timeInterval
          progressBlock:(ProgressBlock _Nullable)progressBlock
                success:(SuccessBlock)successBlock
                   fail:(FailBlock)failBlock
{
     return [self requestWithURL:urlStr requestMethod:HTTP_METHOD_GET params:params timeoutInterval:timeInterval progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
}

/**
 POST请求 JSON参数拼接形式
 */
+ (URLSessionTask *)POSTJSON:(NSString *)urlStr
                      params:(NSDictionary * _Nullable)params
                timeInterval:(NSNumber * _Nullable)timeInterval
                     success:(SuccessBlock)successBlock
                        fail:(FailBlock)failBlock
{
    [JHCNetWorkConfig shareInstance].requestType = [AFHTTPRequestSerializer serializer];
    return [self requestWithURL:urlStr requestMethod:HTTP_METHOD_POST params:params timeoutInterval:timeInterval progressBlock:nil successBlock:successBlock failBlock:failBlock];
}

/**
 上传
 */
+ (URLSessionTask *)UPLOAD:(NSString * _Nullable)urlStr
                    params:(NSDictionary * _Nullable)params
           timeoutInterval:(NSNumber * _Nullable)timeoutInterval
                  fileData:(NSData * _Nullable)fileData
                  fileName:(NSString * _Nullable)fileName
                      name:(NSString * _Nullable)name
                  mimeType:(NSString * _Nullable)mimeType
                  progress:(ProgressBlock)progressBlock
                   success:(SuccessBlock)successBlock
                      fail:(FailBlock)failBlock
{
    //url的处理
    if(!urlStr || !urlStr.length) return nil;
    if(![urlStr hasPrefix:@"http"] && ![urlStr hasPrefix:@"https"]){
        //获取服务器配置的地址,并完整拼接
        NSString *serverAddress = [JHCNetServerConfig getServerURL];
        if ([urlStr hasPrefix:@"/"]) {
            urlStr = [urlStr substringFromIndex:1];
        }
        urlStr = [serverAddress stringByAppendingString:urlStr];
    }
    //URL编码
    if([JHCNetWorkConfig shareInstance].shouldEncodeURL){
        [self encodeURL:urlStr];
    }
    
    //创建会话对象
    AFHTTPSessionManager *mgr = [self getManagerWithTimeInterval:timeoutInterval withUrl:urlStr];
    
    //配置公共参数
    params = params ? [params mutableCopy] : @{}.mutableCopy;
    for (NSString *key in [JHCNetWorkConfig shareInstance].httpParameters) {
        [params setValue:[JHCNetWorkConfig shareInstance].httpParameters[key] forKey:key];
    }
    
    URLSessionTask *sessionTask = nil;
    //弱引用
    __weak typeof(self) weakSelf = self;
    sessionTask = [mgr POST:urlStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接流文件
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progressBlock){
            progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //1.数据处理
        id responseObj = [weakSelf tryToParseData:responseObject];
        
        //2.日志的输出
        if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
            [weakSelf logSuccessResponse:responseObj urlStr:urlStr params:params];
        }
        
        //3.执行回调函数
        if(successBlock){
            [weakSelf successResponse:responseObj callBack:successBlock];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //1.执行失败的回调
        if(failBlock){
            [weakSelf failResponse:error callBack:failBlock];
        }
        
        //2.打印日志
        if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
            [weakSelf logWithFailError:error url:urlStr params:params];
        }
    }];
    
    return sessionTask;
}

/**
 定制化开发
 */
+ (URLSessionTask *)UPLOAD:(NSString * _Nullable)urlStr
                    params:(NSDictionary * _Nullable)params
           timeoutInterval:(NSNumber * _Nullable)timeoutInterval
          constructingBody:(ConstructingBodyBlock)constructingBodyBlock
                  progress:(ProgressBlock)progressBlock
                   success:(SuccessBlock)successBlock
                      fail:(FailBlock)failBlock
{
    //url的处理
    if(!urlStr || !urlStr.length) return nil;
    
    if(![urlStr hasPrefix:@"http"] && ![urlStr hasPrefix:@"https"]){
        //获取服务器配置的地址,并完整拼接
        NSString *serverAddress = [JHCNetServerConfig getServerURL];
        if ([urlStr hasPrefix:@"/"]) {
            urlStr = [urlStr substringFromIndex:1];
        }
        urlStr = [serverAddress stringByAppendingString:urlStr];
    }
    //URL编码
    if([JHCNetWorkConfig shareInstance].shouldEncodeURL){
        [self encodeURL:urlStr];
    }
    
    //创建会话对象
    [JHCNetWorkConfig shareInstance].requestType = [AFHTTPRequestSerializer serializer];
    AFHTTPSessionManager *mgr = [self getManagerWithTimeInterval:timeoutInterval withUrl:urlStr];
    
    //配置公共参数
    params = params ? [params mutableCopy] : @{}.mutableCopy;
    for (NSString *key in [JHCNetWorkConfig shareInstance].httpParameters) {
        [params setValue:[JHCNetWorkConfig shareInstance].httpParameters[key] forKey:key];
    }
    
    URLSessionTask *sessionTask = nil;
    //弱引用
    __weak typeof(self) weakSelf = self;
    sessionTask = [mgr POST:urlStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接流文件
        if(constructingBodyBlock){
            constructingBodyBlock(formData);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progressBlock){
            progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //1.数据处理
        id responseObj = [weakSelf tryToParseData:responseObject];
        
        //2.日志的输出
        if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
            [weakSelf logSuccessResponse:responseObj urlStr:urlStr params:params];
        }
        
        //3.执行回调函数
        if(successBlock){
            [weakSelf successResponse:responseObj callBack:successBlock];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //1.执行失败的回调
        if(failBlock){
            [weakSelf failResponse:error callBack:failBlock];
        }
        
        //2.打印日志
        if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
            [weakSelf logWithFailError:error url:urlStr params:params];
        }
    }];
    return sessionTask;
}



#pragma mark + 公共方法
+ (URLSessionTask *)requestWithURL:(NSString *)urlStr
                     requestMethod:(HTTP_METHOD)requestMethod
                            params:(NSDictionary * _Nullable)params
                   timeoutInterval:(NSNumber * _Nullable)timeoutInterval
                     progressBlock:(ProgressBlock _Nullable)progressBlock
                      successBlock:(SuccessBlock)successBlock
                         failBlock:(FailBlock)failBlock
{
    //url的处理
    if (!urlStr || !urlStr.length) return nil;
    if (![urlStr hasPrefix:@"http"] && ![urlStr hasPrefix:@"https"]) {
        //获取服务器配置的地址,并完整拼接
        NSString *serverAddress = [JHCNetServerConfig getServerURL];
        if ([urlStr hasPrefix:@"/"]) {
            urlStr = [urlStr substringFromIndex:1];
        }
        urlStr = [serverAddress stringByAppendingString:urlStr];
    }
    //URL编码
    if([JHCNetWorkConfig shareInstance].shouldEncodeURL){
        [self encodeURL:urlStr];
    }
    
    //创建会话对象
    AFHTTPSessionManager *mgr = [self getManagerWithTimeInterval:timeoutInterval withUrl:urlStr];
    
    //配置公共参数
    params = params ? [params mutableCopy] : @{}.mutableCopy;
    for (NSString *key in [JHCNetWorkConfig shareInstance].httpParameters) {
        [params setValue:[JHCNetWorkConfig shareInstance].httpParameters[key] forKey:key];
    }
    
    URLSessionTask *sessionTask = nil;
    //弱引用
    __weak typeof(self) weakSelf = self;
    
    if(requestMethod == HTTP_METHOD_GET){ //Get请求
        
        sessionTask = [mgr GET:urlStr parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            if(progressBlock){
                progressBlock(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //1.数据处理
            id responseObj = [weakSelf tryToParseData:responseObject];
            
            //2.日志的输出
            if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
                [weakSelf logSuccessResponse:responseObj urlStr:urlStr params:params];
            }
            
            //3.执行回调函数
            if(successBlock){
                [weakSelf successResponse:responseObj callBack:successBlock];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //1.执行失败的回调
            if(failBlock){
                [weakSelf failResponse:error callBack:failBlock];
            }
            
            //2.打印日志
            if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
                [weakSelf logWithFailError:error url:urlStr params:params];
            }
        }];
    }else if(requestMethod == HTTP_METHOD_POST){ //Post请求
        
        [mgr POST:urlStr parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            if(progressBlock){
                progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //1.数据处理
            id responseObj = [weakSelf tryToParseData:responseObject];
            
            //2.日志的输出
            if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
                [weakSelf logSuccessResponse:responseObj urlStr:urlStr params:params];
            }
            
            //3.执行回调函数
            if(successBlock){
                [weakSelf successResponse:responseObj callBack:successBlock];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //2.打印日志
            if([JHCNetWorkConfig shareInstance].isEnableDebugLog){
                [weakSelf logWithFailError:error url:urlStr params:params];
            }
            
            
            //1.执行失败的回调
            if(failBlock){
                [weakSelf failResponse:error callBack:failBlock];
            }
            
            
        }];
    }
    return sessionTask;
}


#pragma mark + 私有方法
/**
 创建请求对象
 */
+ (AFHTTPSessionManager *)getManagerWithTimeInterval:(NSNumber *)timeInterval withUrl:(NSString *)urlString
{
    //回话对象
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    AFHTTPSessionManager *mgr = [JHCNetWorking shareInstance].manager;
    mgr.requestSerializer = [JHCNetWorkConfig shareInstance].requestType;
    mgr.responseSerializer = [JHCNetWorkConfig shareInstance].responseType;
    mgr.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    mgr.securityPolicy = securityPolicy;

    
    //配置公共头信息
    for (NSString *key in [JHCNetWorkConfig shareInstance].httpHeaders.allKeys) {
        [mgr.requestSerializer setValue:[JHCNetWorkConfig shareInstance].httpHeaders[key] forHTTPHeaderField:key];
    }
    
    [mgr.requestSerializer setValue:@"50excom" forHTTPHeaderField:@"EXID"];
    [mgr.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"myclient"]; // 渠道, ios-未开通，只能传android
    [mgr.requestSerializer setValue:@"6.1.1" forHTTPHeaderField:@"app-version"];
    [mgr.requestSerializer setValue:@"zh-Hans" forHTTPHeaderField:@"lang"];  // 当前语言，zh_cn en
    
    // url中是以下几个域名时，添加token
    [mgr.requestSerializer setValue:@"m3lkgglrlu7fru3fim4qutun07" forHTTPHeaderField:@"TOKEN"];  // token
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"application/x-download", @"text/html",  @"text/json", @"text/plain", @"text/javascript", @"text/xml",@"image/*"]];
    
    if(timeInterval){
        [mgr.requestSerializer
         willChangeValueForKey:@"timeoutInterval"];
        mgr.requestSerializer.timeoutInterval =
        timeInterval.floatValue; // 默认60s
        [mgr.requestSerializer
         didChangeValueForKey:@"timeoutInterval"];
    }
    mgr.operationQueue.maxConcurrentOperationCount = 3;
    return mgr;
}

//数据流转字典
+ (id)tryToParseData:(id)json
{
    if(!json || json == (id)kCFNull) return nil;
    NSDictionary *dict = nil;
    NSData *jsonData = nil;
    if([json isKindOfClass:[NSDictionary class]]){
        dict = json;
    }else if ([json isKindOfClass:[NSString class]]){
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }
    
    if(jsonData){
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if(![dict isKindOfClass:[NSDictionary class]]) dict = nil;
    }
    return dict;
}

//执行数据请求成功回调
+ (void)successResponse:(id)responseData callBack:(SuccessBlock)successBlock
{
    //获取数据流信息
    if(successBlock){
        successBlock([self tryToParseData:responseData]);
    }
}

//执行数据请求失败的回调
+ (void)failResponse:(NSError *)error callBack:(FailBlock)failBlock
{
    if(failBlock){
        failBlock(error);
    }
}

+ (NSString *)encodeURL:(NSString *)urlStr
{
    if([urlStr respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]){
        static NSString * const kAFCharacterHCeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterHCeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < urlStr.length) {
            NSUInteger length = MIN(urlStr.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [urlStr rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [urlStr substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)urlStr,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
        
    }
}


#pragma mark + 日志的输出
//输出请求成功的日志
+ (void)logSuccessResponse:(id)response urlStr:(NSString *)urlStr params:(NSDictionary *)params
{
    NSLog(@"\n");
    NSLog(@"\n请求成功++请求的URL: %@ \n 参数:%@ \n 请求结果:%@\n\n",[self generateAbsoluteURL:urlStr params:params],params,[self tryToParseData:response]);
}
//输出请求失败的日志
+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params
{
    NSString *format = @" params: ";
    if(!params || ![params isKindOfClass:[NSDictionary class]]){
        format = @"";
        params = @"";
    }
    NSLog(@"\n");
    if([error code] == NSURLErrorCancelled){
        NSLog(@"\n请求被取消++请求的URL: %@ %@%@\n\n",[self generateAbsoluteURL:url params:params],format,params);
    }else{
        
        NSLog(@"请求错误++请求的URL: %@ %@%@ 错误信息:%@",[self generateAbsoluteURL:url params:params],format,params,error);
    }
}
+ (NSString *)generateAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
    
    if(!params || ![params isKindOfClass:[NSDictionary class]] || !params.count ) return url;
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = params[key];
        if([value isKindOfClass:[NSArray class]]){
            continue;
        }else if ([value isKindOfClass:[NSDictionary class]]){
            continue;
        }else if ([value isKindOfClass:[NSSet class]]){
            continue;
        }else{
            queries = [NSString stringWithFormat:@"%@%@=%@&",(queries.length ? queries : @"&"),key,value];
        }
    }
    
    if(queries.length > 1){
        queries = [queries substringToIndex:queries.length-1];
    }
    
    if(([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1){
        if([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location != NSNotFound){
            url = [NSString stringWithFormat:@"%@%@",url,queries];
        }else{
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@",url,queries];
        }
    }
    
    return url.length ? url : queries;
    
}

@end
