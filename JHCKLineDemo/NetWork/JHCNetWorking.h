
#import <Foundation/Foundation.h>
#import "JHCNetWorkConfig.h"


NS_ASSUME_NONNULL_BEGIN


@interface JHCNetWorking : NSObject

/**
 * GET请求 普通
 */
+ (URLSessionTask *)GET:(NSString *)urlStr
                 params:(NSDictionary * _Nullable)params
           timeInterval:(NSNumber * _Nullable)timeInterval
                success:(SuccessBlock)successBlock
                   fail:(FailBlock)failBlock;

/**
 * POST请求 JSON参数拼接形式
 */
+ (URLSessionTask *)POSTJSON:(NSString *)urlStr
                      params:(NSDictionary * _Nullable)params
                timeInterval:(NSNumber * _Nullable)timeInterval
                     success:(SuccessBlock)successBlock
                        fail:(FailBlock)failBlock;

/**
 *  上传接口   参数普通形式
 *
 *    @param fileData                流对象
 *    @param fileName                给文件起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *    @param name                    与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *    @param params                参数
 *    @param timeoutInterval      请求时间 默认30s
 *    @param mimeType                默认为image/jpeg
 *    @param progressBlock        上传进度
 *    @param successBlock            上传成功回调
 *    @param failBlock            上传失败回调
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
                      fail:(FailBlock)failBlock;

/**
 定制化开发
 */
+ (URLSessionTask *)UPLOAD:(NSString * _Nullable)urlStr
                    params:(NSDictionary * _Nullable)params
           timeoutInterval:(NSNumber * _Nullable)timeoutInterval
          constructingBody:(ConstructingBodyBlock)constructingBodyBlock
                  progress:(ProgressBlock)progressBlock
                   success:(SuccessBlock)successBlock
                      fail:(FailBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
