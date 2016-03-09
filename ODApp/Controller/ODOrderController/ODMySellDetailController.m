//
//  ODMySellDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMySellDetailController.h"
#import "ODOrderDetailView.h"

#import "ODAPIManager.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"
#import "ODCancelOrderView.h"
#import "ODDrawbackBuyerOneController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODDrawbackBuyerOneController.h"

@interface ODMySellDetailController () <UITextViewDelegate>


@property(nonatomic, strong) ODOrderDetailView *orderDetailView;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) AFHTTPRequestOperationManager *deliveryManager;
@property(nonatomic, strong) ODCancelOrderView *cancelOrderView;


@property(nonatomic, strong) UIButton *deliveryButton;
@property(nonatomic, strong) UIButton *DealDeliveryButton;
@property(nonatomic, strong) UIButton *reasonButton;
@property(nonatomic, strong) UIScrollView *scroller;

@property(nonatomic, copy) NSString *phoneNumber;


@property(nonatomic, strong) UILabel *reason;

@end

@implementation ODMySellDetailController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.userInteractionEnabled = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];


    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
}

- (void)backAction:(UIBarButtonItem *)sender {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRefrash:) name:ODNotificationSellOrderThirdRefresh object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backRefrash:(NSNotification *)text {

    ODOrderDetailModel *statusModel = self.dataArray[0];
    NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
    NSNotification *notification = [NSNotification notificationWithName:ODNotificationSellOrderSecondRefresh object:nil userInfo:dic];

    [[NSNotificationCenter defaultCenter] postNotification:notification];


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.orderId;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrderInfo parameters:params modelClass:[ODOrderDetailModel class] success:^(id model)
     {
         [weakSelf.dataArray removeAllObjects];
         [weakSelf.dataArray addObject:[model result]];

         ODOrderDetailModel *statusModel = self.dataArray[0];
         NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
         
         if (![self.orderStatus isEqualToString:orderStatue]) {

             NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
             NSNotification *notification = [NSNotification notificationWithName:ODNotificationSellOrderSecondRefresh object:nil userInfo:dic];

             [[NSNotificationCenter defaultCenter] postNotification:notification];
         }
         
         [weakSelf createScroller];
     } failure:^(NSError *error) {
         
     }];
}


- (void)createScroller {

    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.scroller.backgroundColor = [UIColor whiteColor];
    self.scroller.userInteractionEnabled = YES;

    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];

    if ([status isEqualToString:@"-1"]) {

        if (iPhone4_4S) {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 350);

        } else if (iPhone5_5s) {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 220);


        } else {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 100);


        }


    } else {


        if (iPhone4_4S) {
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 250);

        } else if (iPhone5_5s) {

            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 150);

        } else {


            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 50);


        }


    }


    [self.view addSubview:self.scroller];


    if ([status isEqualToString:@"2"]) {

        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.deliveryButton setTitle:@"确认发货" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];


    } else if ([status isEqualToString:@"3"]) {


        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.deliveryButton setTitle:@"确认服务" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];


    }


    else if ([status isEqualToString:@"-2"]) {

        self.DealDeliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.DealDeliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.DealDeliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.DealDeliveryButton setTitle:@"处理退款" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.DealDeliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.DealDeliveryButton addTarget:self action:@selector(DealDeliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.DealDeliveryButton];


    } else if ([status isEqualToString:@"-3"] || [status isEqualToString:@"-4"] || [status isEqualToString:@"-5"]) {

        self.reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.reasonButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        self.reasonButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.reasonButton];


    }
    [self createOrderView];


}


- (void)receiveAction:(UIButton *)sender {

    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";


    [self.navigationController pushViewController:vc animated:YES];


}


- (void)reasonAction:(UIButton *)sender {

    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";


    if ([model.reject_reason isEqualToString:@""]) {

        vc.isRefuseReason = NO;

    } else {

        vc.isRefuseReason = YES;
        vc.refuseReason = model.reject_reason;
    }


    [self.navigationController pushViewController:vc animated:YES];


}


- (void)DealDeliveryAction:(UIButton *)sender {

    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isRefuseAndReceive = YES;
    vc.drawbackTitle = @"退款处理";


    [self.navigationController pushViewController:vc animated:YES];


}


- (void)deliveryAction:(UIButton *)sender {


    self.deliveryManager = [AFHTTPRequestOperationManager manager];


    NSString *openId = [ODUserInformation sharedODUserInformation].openID;


    NSDictionary *parameters = @{@"order_id" : self.orderId, @"open_id" : openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    __weak typeof(self) weakSelf = self;
    [self.deliveryManager GET:kDeliveryUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {


        if ([responseObject[@"status"] isEqualToString:@"success"]) {


            [self.deliveryButton removeFromSuperview];


            ODOrderDetailModel *statusModel = self.dataArray[0];
            self.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];


            if (self.getRefresh) {


                weakSelf.getRefresh(@"1");
            }


            [self getData];
            [ODProgressHUD showInfoWithStatus:@"操作成功"];


        } else if ([responseObject[@"status"] isEqualToString:@"error"]) {


            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }

    }                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {


    }];


}


- (void)createOrderView {
    self.orderDetailView = [ODOrderDetailView getView];
    self.orderDetailView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);

    ODOrderDetailModel *model = self.dataArray[0];
    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    NSMutableDictionary *dic = model.user;
    NSMutableDictionary *dic2 = model.order_user;

    [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", dic[@"avatar"]]] forState:UIControlStateNormal];
    self.orderDetailView.nickLabel.text = dic[@"nick"];


    NSMutableArray *arr = model.imgs_small;
    NSMutableDictionary *picDic = arr[0];

    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];


    if ([status isEqualToString:@"-1"]) {


        CGRect rect = [model.address boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 93, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                  context:nil];

        // 订单取消原因
        if ([swap_type isEqualToString:@"2"]) {
            self.reason = [[UILabel alloc] initWithFrame:CGRectMake(18, self.orderDetailView.eightLabel.frame.origin.y + rect.size.height, 100, 20)];

        } else {
            self.reason = [[UILabel alloc] initWithFrame:CGRectMake(18, self.orderDetailView.eightLabel.frame.origin.y + 10, 100, 20)];
        }

        self.reason.backgroundColor = [UIColor whiteColor];
        self.reason.font = [UIFont systemFontOfSize:14];
        self.reason.text = @"订单取消原因";
        self.reason.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:self.reason];

        UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(18, self.reason.frame.origin.y + 30, kScreenSize.width - 18, 1)];
        secondLine.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:secondLine];


        float reasonHeight;
        reasonHeight = [ODHelp textHeightFromTextString:model.reason width:KScreenWidth - 36 miniHeight:35 fontSize:14];
        
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, secondLine.frame.origin.y + 5, kScreenSize.width - 36, reasonHeight)];
        reasonLabel.backgroundColor = [UIColor whiteColor];
        reasonLabel.font = [UIFont systemFontOfSize:14];
        reasonLabel.numberOfLines = 0;
        reasonLabel.text = model.reason;
        reasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reasonLabel];


        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reasonLabel.frame), kScreenSize.width, 6)];
        line.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:line];

        self.orderDetailView.spaceToTop.constant = reasonHeight + 62;
    }

    [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", picDic[@"img_url"]]] forState:UIControlStateNormal];

    self.orderDetailView.contentLabel.text = model.title;
    self.orderDetailView.countLabel.text = [NSString stringWithFormat:@"%@", model.num];
    self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@", model.order_price, model.unit];
    self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元", model.total_price];
    self.orderDetailView.typeLabel.text = self.orderType;

    [self.orderDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];


    if ([swap_type isEqualToString:@"2"]) {

        self.orderDetailView.addressNameLabel.text = model.name;
        self.orderDetailView.addressPhoneLabel.text = model.tel;
        self.phoneNumber = [NSString stringWithFormat:@"%@", model.tel];


        self.orderDetailView.serviceTimeLabel.text = model.address;
        self.orderDetailView.serviceTypeLabel.text = @"服务地址:";
        self.orderDetailView.swapTypeLabel.text = @"快递服务";

    } else {

        NSMutableDictionary *dic = model.order_user;

        self.orderDetailView.addressNameLabel.text = dic2[@"nick"];
        self.orderDetailView.addressPhoneLabel.text = dic2[@"mobile"];

        self.phoneNumber = [NSString stringWithFormat:@"%@", dic[@"mobile"]];


        self.orderDetailView.serviceTimeLabel.text = model.service_time;
        self.orderDetailView.serviceTypeLabel.text = @"服务时间:";
        self.orderDetailView.swapTypeLabel.text = @"线上服务";

    }

    self.orderDetailView.orderTimeLabel.text = model.order_created_at;
    self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@", model.order_id];


    if ([status isEqualToString:@"1"]) {
        self.orderDetailView.typeLabel.text = @"待支付";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"2"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"3"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"4"]) {


        NSString *swap_Type = [NSString stringWithFormat:@"%@", model.swap_type];


        if ([swap_Type isEqualToString:@"2"]) {

            self.orderDetailView.typeLabel.text = @"已发货";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];

        } else {

            self.orderDetailView.typeLabel.text = @"已服务";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
        }

    } else if ([status isEqualToString:@"5"]) {
        self.orderDetailView.typeLabel.text = @"已评价";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-1"]) {
        self.orderDetailView.typeLabel.text = @"已取消";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"-2"]) {
        self.orderDetailView.typeLabel.text = @"买家已申请退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-3"]) {
        self.orderDetailView.typeLabel.text = @"退款已受理";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-4"]) {
        self.orderDetailView.typeLabel.text = @"已退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-5"]) {
        self.orderDetailView.typeLabel.text = @"拒绝退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }

    [self.scroller addSubview:self.orderDetailView];


}

// 打电话
- (void)phoneAction:(UIButton *)sender
{
    [self.view callToNum:self.orderDetailView.addressPhoneLabel.text];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
