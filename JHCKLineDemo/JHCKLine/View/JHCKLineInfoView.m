//
//  JHCKLineInfoView.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/28.
//

#import "JHCKLineInfoView.h"
#import "JHCColors.h"
#import "JHCLabelUtil.h"
#import <Masonry.h>
#import "NSString+JHCDigit.h"


@interface JHCKLineInfoView ()

@property (nonatomic, strong) JHCLabelUtil *fixDateLabel; // 日期
@property (nonatomic, strong) JHCLabelUtil *dateLabel;

@property (nonatomic, strong) JHCLabelUtil *fixOpenLabel; // 开
@property (nonatomic, strong) JHCLabelUtil *openLabel;

@property (nonatomic, strong) JHCLabelUtil *fixHighLabel; // 高
@property (nonatomic, strong) JHCLabelUtil *highLabel;

@property (nonatomic, strong) JHCLabelUtil *fixLowLabel; // 低
@property (nonatomic, strong) JHCLabelUtil *lowLabel;

@property (nonatomic, strong) JHCLabelUtil *fixCloseLabel; // 收
@property (nonatomic, strong) JHCLabelUtil *closeLabel;

@property (nonatomic, strong) JHCLabelUtil *fixAmountLabel; // 涨跌额
@property (nonatomic, strong) JHCLabelUtil *amountLabel;

@property (nonatomic, strong) JHCLabelUtil *fixRateLabel; // 涨跌幅
@property (nonatomic, strong) JHCLabelUtil *rateLabel;

@property (nonatomic, strong) JHCLabelUtil *fixVolLabel; // 成交量
@property (nonatomic, strong) JHCLabelUtil *volLabel;

@end

@implementation JHCKLineInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutBasicView];
    }
    return self;
}

- (void)layoutBasicView
{
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = JHC_Main_Title_Color.CGColor;
    
    NSArray *fixArray = [NSArray arrayWithObjects:self.fixDateLabel, self.fixOpenLabel, self.fixHighLabel, self.fixLowLabel, self.fixCloseLabel, self.fixAmountLabel, self.fixRateLabel, self.fixVolLabel, nil];
    [fixArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [fixArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
    }];
    
    NSArray *valueArray = [NSArray arrayWithObjects:self.dateLabel, self.openLabel, self.highLabel, self.lowLabel, self.closeLabel, self.amountLabel, self.rateLabel, self.volLabel, nil];
    [valueArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [valueArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-5);
    }];
}

- (void)setModel:(JHCKLineModel *)model
{
    _model = model;
    _dateLabel.text = model.date;
    _openLabel.text = [NSString getValueStringWithNumber:model.Open digit:model.priceDigitNum];
    _highLabel.text = [NSString getValueStringWithNumber:model.High digit:model.priceDigitNum];
    _lowLabel.text = [NSString getValueStringWithNumber:model.Low digit:model.priceDigitNum];
    _closeLabel.text = [NSString getValueStringWithNumber:model.Close digit:model.priceDigitNum];
    _volLabel.text = [NSString getValueStringWithNumber:model.Vol digit:model.amountDigitNum];
    
    // 涨跌额 = 收盘价 - 开盘价
    _amountLabel.text = [NSString getValueStringWithNumber:@(model.Close.doubleValue - model.Open.doubleValue).stringValue digit:model.priceDigitNum];
    // 涨跌幅 = (当前收盘价 - 当前开盘价) / 当前开盘价 * 100
    double chg = (([model.Close doubleValue] - [model.Open doubleValue])/ [model.Open doubleValue])*100;
    NSString *changeString = [NSString stringWithFormat:@"%.2f%%", chg];
    if (chg > 0) {
        changeString = [NSString stringWithFormat:@"+%.2f%%",chg];
        _amountLabel.textColor = _rateLabel.textColor = JHC_BuyButton_Color_Normal;
    }else{
        _amountLabel.textColor = _rateLabel.textColor = JHC_SellButton_Color_Normal;
    }
    _rateLabel.text = changeString;
    
    self.backgroundColor = JHCKLineColors_bgColor;
    _fixDateLabel.textColor = _fixHighLabel.textColor = _fixOpenLabel.textColor = _fixLowLabel.textColor = _fixCloseLabel.textColor = _fixAmountLabel.textColor = _fixRateLabel.textColor = _fixVolLabel.textColor = JHC_Main_Title_Color;
    _dateLabel.textColor = _highLabel.textColor = _openLabel.textColor = _lowLabel.textColor = _closeLabel.textColor = _volLabel.textColor = JHC_Main_Title_Color;
}


#pragma mark -- 懒加载
- (JHCLabelUtil *)fixDateLabel
{
    if (_fixDateLabel) return _fixDateLabel;
    _fixDateLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"时间" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixDateLabel];
    return _fixDateLabel;
}
- (JHCLabelUtil *)dateLabel
{
    if (_dateLabel) return _dateLabel;
    _dateLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_dateLabel];
    return _dateLabel;
}

- (JHCLabelUtil *)fixOpenLabel
{
    if (_fixOpenLabel) return _fixOpenLabel;
    _fixOpenLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"开" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixOpenLabel];
    return _fixOpenLabel;
}
- (JHCLabelUtil *)openLabel
{
    if (_openLabel) return _openLabel;
    _openLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_openLabel];
    return _openLabel;
}

- (JHCLabelUtil *)fixHighLabel
{
    if (_fixHighLabel) return _fixHighLabel;
    _fixHighLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"高" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixHighLabel];
    return _fixHighLabel;
}
- (JHCLabelUtil *)highLabel
{
    if (_highLabel) return _highLabel;
    _highLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_highLabel];
    return _highLabel;
}

- (JHCLabelUtil *)fixLowLabel
{
    if (_fixLowLabel) return _fixLowLabel;
    _fixLowLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"低" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixLowLabel];
    return _fixLowLabel;
}
- (JHCLabelUtil *)lowLabel
{
    if (_lowLabel) return _lowLabel;
    _lowLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_lowLabel];
    return _lowLabel;
}

- (JHCLabelUtil *)fixCloseLabel
{
    if (_fixCloseLabel) return _fixCloseLabel;
    _fixCloseLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"收" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixCloseLabel];
    return _fixCloseLabel;
}
- (JHCLabelUtil *)closeLabel
{
    if (_closeLabel) return _closeLabel;
    _closeLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_closeLabel];
    return _closeLabel;
}

- (JHCLabelUtil *)fixAmountLabel
{
    if (_fixAmountLabel) return _fixAmountLabel;
    _fixAmountLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"涨跌额" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixAmountLabel];
    return _fixAmountLabel;
}
- (JHCLabelUtil *)amountLabel
{
    if (_amountLabel) return _amountLabel;
    _amountLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_amountLabel];
    return _amountLabel;
}

- (JHCLabelUtil *)fixRateLabel
{
    if (_fixRateLabel) return _fixRateLabel;
    _fixRateLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"涨跌幅" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixRateLabel];
    return _fixRateLabel;
}
- (JHCLabelUtil *)rateLabel
{
    if (_rateLabel) return _rateLabel;
    _rateLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_rateLabel];
    return _rateLabel;
}

- (JHCLabelUtil *)fixVolLabel
{
    if (_fixVolLabel) return _fixVolLabel;
    _fixVolLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:@"成交量" textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentLeft];
    [self addSubview:_fixVolLabel];
    return _fixVolLabel;
}
- (JHCLabelUtil *)volLabel
{
    if (_volLabel) return _volLabel;
    _volLabel = [JHCLabelUtil createLabelWithFrame:CGRectZero labelText:nil textColor:nil textFont:[UIFont systemFontOfSize:10.f] textAligment:NSTextAlignmentRight];
    [self addSubview:_volLabel];
    return _volLabel;
}


@end
