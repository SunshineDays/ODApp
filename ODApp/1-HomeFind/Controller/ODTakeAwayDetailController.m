//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "PontoH5ToMobileRequest.h"
#import "ODPaySuccessController.h"
#import "ODTakeAwayDetailController.h"
#import "ODShopCartListCell.h"
#import "ODTakeOutModel.h"

#import <Masonry.h>
#import "ODHttpTool.h"
#import "ODUserInformation.h"
#import "ODAPPInfoTool.h"

#import "ODShopCartView.h"

static NSInteger result;
static CGFloat priceResult;

@interface ODTakeAwayDetailController()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@property(nonatomic, copy) NSString *isPay;

@property (nonatomic, weak) ODShopCartView *shopCart;
@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.takeAwayTitle;
    [self createWebView];
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    
    // 订单详情页
    if (self.isOrderDetail) {
        NSString *urlString = [[ODHttpTool getRequestParameter:@{ @"order_id" : self.order_id}]od_URLDesc];
        NSString *url = [ODWebUrlNativeOrderInfo stringByAppendingString:urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
    }
    // 商品详情页
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
        
        [self setupShopCart];
    }
    
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.shopCart.hidden = NO;
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    self.shopCart.hidden = YES;
}

#pragma mark - Create UIWebView
- (void)createWebView {
    float footHeight = 0;
    if (!self.isOrderDetail) {
        footHeight = 49;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - footHeight)];
    [self.view addSubview:self.webView];
}

#pragma mark - 购物车
- (void)setupShopCart
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    [keyWindow addSubview:shopCart];
    self.shopCart = shopCart;
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(keyWindow);
        make.height.equalTo(49);
    }];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    result = [[user objectForKey:@"result"] integerValue];
    priceResult = [[user objectForKey:@"priceResult"] floatValue];
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    self.shops = [NSMutableDictionary dictionaryWithDictionary:cacheShops];
    self.shopCart = shopCart;
    shopCart.shops = self.shops;
    
    // 商品总数量
//    result += 1;
    // 计算数量
    shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)result];
    shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    
    // 读取缓存的shopNumber
    NSDictionary *obj = [cacheShops objectForKey:self.takeOut.title];
    NSInteger cacheNumber = [[obj valueForKey:@"shopNumber"] integerValue];
    
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    
    // 保存商品个数
    self.takeOut.shopNumber = cacheNumber;
    [self.shops setObject:self.takeOut.mj_keyValues forKey:self.takeOut.title];
    self.shopCart.shops = self.shops;
    
    // 保存数据
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user setObject:self.shops forKey:@"shops"];
    [user synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        for (UIView *childView in [UIApplication sharedApplication].keyWindow.subviews)
        {
            if (childView == self. shopCart) [self.shopCart removeFromSuperview];
        }
    }];
  
}

#pragma mark - 初始化方法
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusShopCart:) name:ODNotificationShopCartAddNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusShopCart:) name:ODNotificationShopCartminusNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllDatas:) name:ODNotificationShopCartRemoveALL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addShopNumber:) name:@"test" object:nil];
}

- (void)addShopNumber:(NSNotification *)note
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    result = [[user objectForKey:@"result"] integerValue];
    NSInteger number = self.takeOut.shopNumber;
    result += 1;
    number += 1;
    priceResult += self.takeOut.price_show.floatValue;
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", result];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    self.takeOut.shopNumber = result;
    
    // 更新模型
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSMutableDictionary *obj = [cacheShops objectForKey:self.takeOut.title];
    NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:obj];
    // 修改数量
    [mutableItem setObject:@(number) forKey:@"shopNumber"];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *key in cacheShops)
    {
        NSDictionary *dict = cacheShops[key];
        if ([dict isEqual:obj]) {
            [dictM setObject:mutableItem forKey:key];
        } else {
            [dictM setObject:dict forKey:key];
        }
    }
    self.shopCart.shops = dictM;
    [self.shopCart.shopCartView reloadData];
    [user setObject:dictM forKey:@"shops"];
    [user setObject:@(result) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user synchronize];
    if ([self.takeAwayTitle isEqualToString:@"订单详情"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPay:) name:ODNotificationPaySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay:) name:ODNotificationPayfail object:nil];
    }
}

- (void)removeAllDatas:(NSNotification *)note
{
    result = 0;
    priceResult = 0;
    [self.shops removeAllObjects];
    [self.shopCart.shopCartView reloadData];
    self.shopCart.buyButton.enabled = NO;
}

- (void)plusShopCart:(NSNotification *)note
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    ODShopCartListCell *cell = note.object;
    NSInteger number = cell.takeOut.shopNumber;
    
    result = [[user objectForKey:@"result"] integerValue];
    result += 1;
    priceResult += cell.takeOut.price_show.floatValue;

    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    
    // 更新模型
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSMutableDictionary *obj = [cacheShops objectForKey:cell.takeOut.title];
    NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:obj];
    // 修改数量
    [mutableItem setObject:@(number) forKey:@"shopNumber"];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *key in cacheShops)
    {
        NSDictionary *dict = cacheShops[key];
        if ([dict isEqual:obj]) {
            [dictM setObject:mutableItem forKey:key];
        } else {
            [dictM setObject:dict forKey:key];
        }
    }
    
    [self.shopCart.shopCartView reloadData];
    [user setObject:dictM forKey:@"shops"];
    [user setObject:@(number) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user synchronize];
}

- (void)minusShopCart:(NSNotification *)note
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    ODShopCartListCell *cell = note.object;
    NSInteger number = cell.takeOut.shopNumber;
    
    result = [[user objectForKey:@"result"] integerValue];
    result -= 1;
    if (!number) {
        [self.shopCart.shops removeObjectForKey:cell.takeOut.title];
        [user setObject:self.shopCart.shops forKey:@"shops"];
    }
    priceResult -= cell.takeOut.price_show.floatValue;
    self.shopCart.numberLabel.text = [NSString stringWithFormat:@"%ld", number];
    self.shopCart.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", priceResult];
    // 更新模型
    NSMutableDictionary *cacheShops = [user objectForKey:@"shops"];
    NSMutableDictionary *obj = [cacheShops objectForKey:cell.takeOut.title];
    NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:obj];
    // 修改数量
    [mutableItem setObject:@(number) forKey:@"shopNumber"];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (NSString *key in cacheShops)
    {
        NSDictionary *dict = cacheShops[key];
        if ([dict isEqual:obj]) {
            [dictM setObject:mutableItem forKey:key];
        } else {
            [dictM setObject:dict forKey:key];
        }
    }
    [self.shopCart.shopCartView reloadData];
    [user setObject:dictM forKey:@"shops"];
    [user setObject:@(number) forKey:@"result"];
    [user setObject:@(priceResult) forKey:@"priceResult"];
    [user synchronize];
}

- (void)getDatawithCode:(NSString *)code {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"order_no"] = self.model.out_trade_no;
    params[@"errCode"] = code;
    params[@"type"] = @"1";
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlPayWeixinCallbackSync parameters:params modelClass:[NSObject class] success:^(id model)
     {
         for (UIViewController *vc in weakSelf.navigationController.childViewControllers)
         {
             if ([vc isKindOfClass:[ODPaySuccessController class]])
             {
                 return ;
             }
         }
         ODPaySuccessController *vc = [[ODPaySuccessController alloc] init];
//         vc.swap_type = weakSelf.swap_type;
         vc.payStatus = weakSelf.isPay;
//         vc.orderId = weakSelf.orderId;
//         vc.params = [PontoH5ToMobileRequest ].;
         vc.tradeType = @"1";
         [weakSelf.navigationController pushViewController:vc animated:YES];
     } failure:^(NSError *error) {
         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - 事件方法
- (void)failPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"2";
    [self getDatawithCode:code];
}

- (void)successPay:(NSNotification *)text {
    NSString *code = text.userInfo[@"codeStatus"];
    self.isPay = @"1";
    [self getDatawithCode:code];
}

@end
