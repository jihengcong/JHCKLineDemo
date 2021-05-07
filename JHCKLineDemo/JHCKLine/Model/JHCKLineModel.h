//
//  JHCKLineModel.h
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface JHCKLineModel : NSObject

@property (nonatomic, copy) NSString *Open; // 开
@property (nonatomic, copy) NSString *High; // 高
@property (nonatomic, copy) NSString *Low; // 低
@property (nonatomic, copy) NSString *Close; // 收

@property (nonatomic, copy) NSString *Vol; // 成交量
@property (nonatomic, copy) NSString *Amount; // 成交额
@property (nonatomic, copy) NSString *Count;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *MA5Price;
//@property (nonatomic, copy) NSString *MA7Price;
@property (nonatomic, copy) NSString *MA10Price;
@property (nonatomic, copy) NSString *MA20Price;
@property (nonatomic, copy) NSString *MA30Price;

@property (nonatomic, copy) NSString *MA5Volume;
//@property (nonatomic, copy) NSString *MA7Volume;
@property (nonatomic, copy) NSString *MA10Volume;
//@property (nonatomic, copy) NSString *MA20Volume;
//@property (nonatomic, copy) NSString *MA30Volume;

@property (nonatomic, copy) NSString *mb;
@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *dn;

@property (nonatomic, copy) NSString *dif;
@property (nonatomic, copy) NSString *dea;
@property (nonatomic, copy) NSString *MACD;
@property (nonatomic, copy) NSString *EMA12;
@property (nonatomic, copy) NSString *EMA26;

@property (nonatomic, copy) NSString *RSI;
@property (nonatomic, copy) NSString *RSI_ABSEMA;
@property (nonatomic, copy) NSString *RSI_MaxEMA;

@property (nonatomic, copy) NSString *K;
@property (nonatomic, copy) NSString *D;
@property (nonatomic, copy) NSString *J;
@property (nonatomic, copy) NSString *R;

// 以下为自定义的两个字段
@property (nonatomic, assign) NSInteger priceDigitNum;
@property (nonatomic, assign) NSInteger amountDigitNum;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWithArray:(NSArray *)array;

@end


NS_ASSUME_NONNULL_END
