//
//  JHCKLineModel.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineModel.h"


@implementation JHCKLineModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
        
        _High = [NSString stringWithFormat:@"%@", @([dict[@"High"] doubleValue]).stringValue];
        _Low = [NSString stringWithFormat:@"%@", @([dict[@"Low"] doubleValue]).stringValue];
        _Open = [NSString stringWithFormat:@"%@", @([dict[@"Open"] doubleValue]).stringValue];
        _Close = [NSString stringWithFormat:@"%@", @([dict[@"Close"] doubleValue]).stringValue];
        _Amount = [NSString stringWithFormat:@"%@", @([dict[@"Amount"] doubleValue]).stringValue];
        _Vol = [NSString stringWithFormat:@"%@", @([dict[@"Vol"] doubleValue]).stringValue];
        _Count = [NSString stringWithFormat:@"%@", @([dict[@"Count"] doubleValue]).stringValue];
        _date = [NSString stringWithFormat:@"%@", @([dict[@"date"] doubleValue]).stringValue];
        
        _priceDigitNum = _amountDigitNum = 2;
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        _date = [self formatDateText:[array[0] doubleValue]];
//        _date = [NSString stringWithFormat:@"%@", @([array[0] doubleValue]).stringValue];
        _Open = [NSString stringWithFormat:@"%@", @([array[1] doubleValue]).stringValue];
        _High = [NSString stringWithFormat:@"%@", @([array[2] doubleValue]).stringValue];
        _Low = [NSString stringWithFormat:@"%@", @([array[3] doubleValue]).stringValue];
        _Close = [NSString stringWithFormat:@"%@", @([array[4] doubleValue]).stringValue];
        _Vol = [NSString stringWithFormat:@"%@", @([array[5] doubleValue]).stringValue];
        
        _priceDigitNum = _amountDigitNum = 2;
        
//        _Amount = [NSString stringWithFormat:@"%@", array[0]];
//        _Count = [NSString stringWithFormat:@"%@", array[0]];
    }
    return self;
}


// 格式化日期显示
- (NSString *)formatDateText:(NSTimeInterval)time
{
    if (time > 1000000000000) {
        time /= 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *string = [formatter stringFromDate:date];
    return string;
}


- (void)setPriceDigitNum:(NSInteger)priceDigitNum
{
    _priceDigitNum = priceDigitNum;
}

- (void)setAmountDigitNum:(NSInteger)amountDigitNum
{
    _amountDigitNum = amountDigitNum;
}


@end
