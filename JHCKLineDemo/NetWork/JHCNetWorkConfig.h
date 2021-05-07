
#import <Foundation/Foundation.h>
#import <AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN


/**
 * 下载进度
 *
 * @param bytesRead            已下载大小
 * @param totalBytesRead       文件总大小
 */
typedef void (^ProgressBlock)(int64_t bytesRead,int64_t totalBytesRead);

/**
 * 网络响应成功的回调
 *
 * @param responseObject   服务器端返回的数据类型
 */
typedef void (^ResponseSuccess)(id _Nullable responseObject);


typedef void (^ConstructingBodyBlock)(id<AFMultipartFormData> _Nonnull formData);

/**
 * 网络响应失败的回调
 *
 * @param error     错误信息
 */
typedef void (^ResponseFail)(NSError * _Nullable error);


typedef NS_ENUM(NSUInteger, RZNetworkResponseType) {
    RZNetworkResponseType_JSON = 0x22 , //默认
    RZNetworkResponseType_XML         , //XML
    RZNetworkResponseType_HTTP        , //二进制格式
    RZNetworkResponseType_IMAGE       , //图片格式
    
};

typedef NS_ENUM(NSUInteger, RZNetworkRequestType) {
    RZNetworkRequestType_HTTP      = 0x11, //默认
    RZNetworkRequestType_JSON                 , //普通的text/html
};

typedef NS_ENUM(NSInteger, RZNetworkStatus) {
    RZNetworkStatusUnknown          = -1,  //未知网络
    RZNetworkStatusNotReachable     =  0,  //网络无连接
    RZNetworkStatusReachableViaWAN  =  1,  //2G/3G/4G
    RZNetworkStatusReachableViaWiFi =  2   //WIFI网络
};


/**
 * 网络响应成功的回调
 *
 * @param responseObject   服务器端返回的数据类型
 */
typedef void (^SuccessBlock)(id _Nullable responseObject);
/**
 * 网络响应失败的回调
 *
 * @param error     错误信息
 */
typedef void (^FailBlock)(NSError *_Nullable error);

/**
 * 所有接口返回值均为NSURLSessionTask
 *
 */
typedef NSURLSessionTask URLSessionTask;



/**
 * 网络请求配置
 **/
@interface JHCNetWorkConfig : NSObject

/**
 * 单例
 */
+ (instancetype)shareInstance;

//默认配置
- (void)defaultConfig;


@property (nonatomic,strong) AFHTTPResponseSerializer *_Nullable responseType;     //数据返回格式 默认是 ResponseType_JSON
@property (nonatomic,strong) AFHTTPRequestSerializer  *_Nullable requestType;      //数据的请求格式 默认是 RequestType_HTTP

@property (nonatomic,strong,readonly) NSDictionary * _Nullable httpHeaders;          //公共请求头信息
@property (nonatomic,strong,readonly) NSDictionary * _Nullable httpParameters;       //公共请求参数


@property (nonatomic,assign) BOOL              isEnableDebugLog; //开启或者关闭接口打印信息  默认是开启
@property (nonatomic,assign) BOOL              shouldEncodeURL;  //是否对URL编码   默认开启

/**
 * 配置公共的请求头，只调用一次即可
 *
 * @param  httpHeaders      只需要将与服务器商定的固定参数设置即可
 */
- (void)configCommonHTTPHeaders:(NSDictionary * _Nullable)httpHeaders;

/**
 * 配置公共的参数
 *
 * @param  httpParams      只需要将与服务器商定的固定参数设置即可
 */
- (void)configCommonHTTPParams:(NSDictionary * _Nullable)httpParams;


@end


NS_ASSUME_NONNULL_END
