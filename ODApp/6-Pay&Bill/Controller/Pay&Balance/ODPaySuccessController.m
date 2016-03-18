//
//  ODPaySuccessController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODPaySuccessController.h"
#import "ODPaySuccessView.h"
#import "ODOrderDetailController.h"
#import "ODSecondOrderDetailController.h"
#import "ODBazaarViewController.h"
#import "ODCancelOrderView.h"
#import "Masonry.h"

@interface ODPaySuccessController () <UITextViewDelegate>

@property(nonatomic, strong) ODPaySuccessView *paySuccessView;
@property(nonatomic, strong) ODCancelOrderView *cancelOrderView;
@property(nonatomic, copy) NSString *isCancel;

@end

@implementation ODPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"支付订单";
    [self.view addSubview:self.paySuccessView];
    [self.paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
}


#pragma mark - 懒加载

- (ODPaySuccessView *)paySuccessView {
    if (_paySuccessView == nil) {

        self.paySuccessView = [ODPaySuccessView getView];

        if ([self.payStatus isEqualToString:@"1"]) {

            self.paySuccessView.isSuccessLabel.text = @"您的订单已支付成功";
            self.paySuccessView.isSuccessView.image = [UIImage imageNamed:@"icon_background_"];
            
            [self.paySuccessView.isSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@213);
            }];

            [self.paySuccessView.firstButton setTitle:@"订单详情" forState:UIControlStateNormal];
            [self.paySuccessView.firstButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];

            [self.paySuccessView.secondButton setTitle:@"再去逛逛" forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(goOther:) forControlEvents:UIControlEventTouchUpInside];

        } else if ([self.payStatus isEqualToString:@"2"]) {

            self.paySuccessView.isSuccessLabel.text = @"对不起您的订单支付失败";
            self.paySuccessView.isSuccessView.image = [UIImage imageNamed:@"icon_Payment failure_background-1"];
            
            [self.paySuccessView.isSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@161);
            }];

            [self.paySuccessView.firstButton setTitle:@"重新支付" forState:UIControlStateNormal];
            [self.paySuccessView.firstButton addTarget:self action:@selector(PayAgain:) forControlEvents:UIControlEventTouchUpInside];

            [self.paySuccessView.secondButton setTitle:@"订单详情" forState:UIControlStateNormal];
            [self.paySuccessView.secondButton addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
        }


    }
    return _paySuccessView;
}


- (void)PayAgain:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


// 订单详情
- (void)orderDetail:(UIButton *)sender {

    if ([self.swap_type isEqualToString:@"1"]) {
        ODSecondOrderDetailController *vc = [[ODSecondOrderDetailController alloc] init];
        vc.order_id = [NSString stringWithFormat:@"%@", self.orderId];

        [self.navigationController pushViewController:vc animated:YES];

    } else {

        ODOrderDetailController *vc = [[ODOrderDetailController alloc] init];
        vc.order_id = [NSString stringWithFormat:@"%@", self.orderId];
        [self.navigationController pushViewController:vc animated:YES];


    }


}

// 再去逛逛
- (void)goOther:(UIButton *)sender {

    ODTabBarController *tabBar = (ODTabBarController *) self.tabBarController;
    if (tabBar.currentIndex == 2) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        tabBar.selectedIndex = 2;
        ODBazaarViewController *vc = tabBar.childViewControllers[2].childViewControllers[0];
        vc.index = 0;
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end