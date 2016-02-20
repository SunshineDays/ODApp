//
//  ODWithdrawalController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODWithdrawalController.h"
#import "ODWithdrawalView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODWithdrawalController ()<UITextViewDelegate>

@property (nonatomic , strong) ODWithdrawalView *withdrawalView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;


@end

@implementation ODWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:self.withdrawalView];
    
}


#pragma mark - 懒加载
- (ODWithdrawalView *)withdrawalView
{
    if (_withdrawalView == nil) {
        self.withdrawalView = [ODWithdrawalView getView];
        self.withdrawalView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        
        self.withdrawalView.prcieLabel.text = self.price;
        self.withdrawalView.payAddressTextView.delegate = self;
        [self.withdrawalView.withdrawalButton addTarget:self action:@selector(withdrawalAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _withdrawalView;
}


- (void)withdrawalAction:(UIButton *)sender
{
    
    if ([self.withdrawalView.payAddressTextView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"] || [self.withdrawalView.payAddressTextView.text isEqualToString:@""]) {
        
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入支付宝账号"];
    }else {
        
        [self getData];
        
        
    }
    
    
}


#pragma mark - 请求数据
- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    NSDictionary *parameters = @{@"amount":self.withdrawalView.prcieLabel.text,@" account":self.withdrawalView.payAddressTextView.text ,  @"open_id":openId};
    
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kBalanceUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
          
            
            [self.navigationController popViewControllerAnimated:YES];
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"提现成功"];

            
        }
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
          
        
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        
        }

        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}



#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.withdrawalView.payAddressTextView.text isEqualToString:@"请输入和注册手机一致的支付宝账号"] || [self.withdrawalView.payAddressTextView.text isEqualToString:@""]) {
       self.withdrawalView.payAddressTextView.text = @"请输入和注册手机一致的支付宝账号";
    self.withdrawalView.payAddressTextView.textColor = [UIColor lightGrayColor];
    }
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end