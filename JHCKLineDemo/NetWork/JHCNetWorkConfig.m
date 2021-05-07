
#import "JHCNetWorkConfig.h"


@interface JHCNetWorkConfig () <NSCopying,NSMutableCopying>

@end

@implementation JHCNetWorkConfig


#pragma mark - 单例的实现
static JHCNetWorkConfig * _shareInstance;
+ (instancetype)shareInstance
{
    if(_shareInstance == nil){
        _shareInstance = [[JHCNetWorkConfig alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(_shareInstance == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
            //默认配置
            [_shareInstance defaultConfig];
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


#pragma mark - 私有方法

- (void)defaultConfig
{
    self.requestType = [AFJSONRequestSerializer serializer];
    self.responseType = [AFJSONResponseSerializer serializer];
#if DEBUG
    self.isEnableDebugLog = YES;
#else
    self.isEnableDebugLog = NO;
#endif
    self.shouldEncodeURL = YES;
}

/**
 * 配置公共的请求头，只调用一次即可
 *
 * @param  httpHeaders      只需要将与服务器商定的固定参数设置即可
 */
- (void)configCommonHTTPHeaders:(NSDictionary *)httpHeaders
{
    
    self.httpHeaders = [httpHeaders copy];
}

/**
 * 配置公共的参数
 *
 * @param  httpParams      只需要将与服务器商定的固定参数设置即可
 */
- (void)configCommonHTTPParams:(NSDictionary *)httpParams
{
    self.httpParameters = [httpParams copy];
}

#pragma mark - setter方法
- (void)setHttpHeaders:(NSDictionary *)httpHeaders
{
    _httpHeaders = httpHeaders;
}
- (void)setHttpParameters:(NSDictionary *)httpParameters
{
    _httpParameters = httpParameters;
}



@end
