//
//  JHCViewController.m
//  JHCKLineDemo
//
//  Created by mac on 2020/12/29.
//

#import "JHCViewController.h"
#import "JHCKLineView.h"
#import "JHCKLineDataTool.h"
#import "JHCKLineStateManager.h"
#import "JHCKLineTheme.h"
#import "JHCColors.h"
#import "JHCNetWorking.h"
#import <Masonry.h>


@interface JHCViewController ()

@property (nonatomic, strong) JHCKLineView *klineView;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy) NSString *pair;
@property (nonatomic, assign) NSInteger count;

@end

@implementation JHCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = JHCKLineColors_bgColor;
    
    _pair = @"BTC_USDT";
    _count = 0;
    
    [JHCKLineStateManager sharedManager].klineView = self.klineView;
//    _klineView.isTimeLine = YES;
//    [self fetchDatas];
    
    kWeakSelf(weakSelf)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC, 0.01 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        
        [weakSelf addData];
        
//        weakSelf.count ++;
//        if (weakSelf.count >= 5) {
//            weakSelf.pair = @"ETH_USDT";
//        }
//        if (weakSelf.count >= 10) {
//            weakSelf.count = 0;
//            weakSelf.pair = @"BTC_USDT";
//        }
    });
    dispatch_resume(_timer);
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"切换主题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(weakSelf.klineView.mas_bottom).offset(50);
        make.size.mas_offset(CGSizeMake(100, 40));
    }];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectZero];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"切换分时" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(button.mas_bottom).offset(20);
        make.size.mas_offset(CGSizeMake(100, 40));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [JHCKLineStateManager sharedManager].isFlashKLine = NO;
}

- (void)buttonAction:(UIButton *)button
{
    BOOL isThemeWhite = [JHCKLineStateManager sharedManager].isThemeWhite;
    [JHCKLineStateManager sharedManager].isThemeWhite = !isThemeWhite;

    self.view.backgroundColor = !isThemeWhite ? [UIColor whiteColor] : JHCKLineColors_bgColor;
    
//    [JHCKLineStateManager sharedManager].mainState = (JHCKLineMainState)arc4random()%3;
//    [JHCKLineStateManager sharedManager].volState = JHCKLineVolState_NONE;
//    [JHCKLineStateManager sharedManager].secondaryState = JHCKLineSecondaryState_NONE;
}

- (void)timeButtonAction:(UIButton *)button
{
//    BOOL isTimeLine = [JHCKLineStateManager sharedManager].isTimeLine;
//    [JHCKLineStateManager sharedManager].isTimeLine = !isTimeLine;
    
    [JHCKLineStateManager sharedManager].secondaryState = (JHCKLineSecondaryState)arc4random()%5;
}


- (void)fetchDatas
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kline" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dict = array[i];
        JHCKLineModel *model = [[JHCKLineModel alloc] initWithDict:dict];
        [dataSource addObject:model];
    }
    [JHCKLineDataTool calculate:dataSource];
    [JHCKLineStateManager sharedManager].models = dataSource;
    _klineView.datas = dataSource;
}

- (void)addData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"1m";
    param[@"symbol"] = _pair;
    param[@"limit"] = @"100";
    
    kWeakSelf(weakSelf)
    NSString *url = @"https://wapi.myfastapi.com/cd_kline/k_data_new";
    [JHCNetWorking GET:url params:param timeInterval:nil success:^(id _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1)
        {
            NSMutableArray *modelArray = [NSMutableArray array];
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([[dict allKeys] containsObject:@"data"])
            {
                NSDictionary *listDict = dict[@"data"];
                if ([[listDict allKeys] containsObject:@"lists"])
                {
                    NSArray *array = listDict[@"lists"];
                    for (NSInteger i = array.count - 1; i >= 0; i --)
                    {
                        JHCKLineModel *model = [[JHCKLineModel alloc] initWithArray:array[i]];
                        [modelArray addObject:model];
                    }
                }
                [JHCKLineDataTool calculate:modelArray];
                [JHCKLineStateManager sharedManager].models = modelArray;
                weakSelf.klineView.datas = modelArray;
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


- (JHCKLineView *)klineView
{
    if (_klineView) return _klineView;
//    _klineView = [[JHCKLineView alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, 450)];
    _klineView = [[JHCKLineView alloc] initWithFrame:CGRectZero];
    _klineView.direction = JHCKLineDirection_Vertical;
//    [self.view addSubview:_klineView];
    [self.view addSubview:_klineView];
    [_klineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(88);
        make.height.mas_offset(450);
    }];
    return _klineView;
}


@end
