//
//  ODActivityDetailController.m
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODActivityDetailController.h"
#import "ActivityDetailView.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "ODTabBarController.h"
#import "ODUserInformation.h"
#import "ODCenterDetailController.h"
@interface ODActivityDetailController ()<UITableViewDelegate , UIWebViewDelegate>


@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ActivityDetailView *activityDetailView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;


@property(nonatomic,strong)ActivityModel *model;
@property(nonatomic,strong)UIView *foodView;
@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIScrollView *scroller;



@end

@implementation ODActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
       
    
     [self navigationInit];
   
     [self getData];
    
     self.openId = [ODUserInformation getData].openID;
    
           
}



#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    
//    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    
//    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 连接数据
- (void)saveData
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameter = @{@"open_id":self.openId , @"activity_id":self.activityId , @"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/apply";
    
    
    [self.managers GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            
            NSString *need_verify = [NSString stringWithFormat:@"%ld" , (long)self.model.need_verify];
            
            if ([need_verify isEqualToString:@"0"]) {
                
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"报名成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alter show];
                
                
                [self.activityDetailView.baoMingButton setTitle:@"已报名" forState:UIControlStateNormal];
                [self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                            forState:UIControlStateNormal];
                self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
                self.activityDetailView.baoMingButton.userInteractionEnabled = NO;

            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"已报名等待审核" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alter show];
                
                
                [self.activityDetailView.baoMingButton setTitle:@"已报名" forState:UIControlStateNormal];
                [self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                            forState:UIControlStateNormal];
                self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
                self.activityDetailView.baoMingButton.userInteractionEnabled = NO;

            }
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:responseObject[@"message"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定", nil];
            [alter show];
            
            
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
}


- (void)getData
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameter = @{@"activity_id":self.activityId , @"store_id":self.storeId ,@"open_id":self.openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
  
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/apply/detail";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
            
                   
            self.model = [[ActivityModel alloc] initWithDict:result];
            
            
            
            [weakSelf creatView];

            
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
    
}

#pragma mark - 初始化
-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 选择中心label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"中心活动" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [self.headView addSubview:confirmButton];
    
}

- (void)creatView
{
    
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)];
    self.scroller.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    self.activityDetailView = [ActivityDetailView getView];
    
    
    [self.activityDetailView.titleImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.model.icon_url]];
    [self.activityDetailView.baoMingButton addTarget:self action:@selector(baoMingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *status = [NSString stringWithFormat:@"%ld" , (long)self.model.apply_status];
    
    if ([status isEqualToString:@"-2"]) {
        
        [self.activityDetailView.baoMingButton setTitle:@"报名时间已结束" forState:UIControlStateNormal];
        [ self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                     forState:UIControlStateNormal];
        self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        self.activityDetailView.baoMingButton.userInteractionEnabled = NO;
        
        
    } else if ([status isEqualToString:@"-3"]) {
        
        [self.activityDetailView.baoMingButton setTitle:[NSString stringWithFormat:@"报名%@开始" , self.model.apply_start_time] forState:UIControlStateNormal];
        [ self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                     forState:UIControlStateNormal];
        self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        self.activityDetailView.baoMingButton.userInteractionEnabled = NO;
        
        
    }
    
    
    
    else if ([status isEqualToString:@"-4"] ||[status isEqualToString:@"-5"] ) {
        
        [self.activityDetailView.baoMingButton setTitle:@"人数已满" forState:UIControlStateNormal];
        [self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                    forState:UIControlStateNormal];
        self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        self.activityDetailView.baoMingButton.userInteractionEnabled = NO;
        
    }else if (![status isEqualToString:@"-100"]) {
        [self.activityDetailView.baoMingButton setTitle:@"已报名" forState:UIControlStateNormal];
        [self.activityDetailView.baoMingButton setTitleColor:[UIColor blackColor]
                                                    forState:UIControlStateNormal];
        self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        self.activityDetailView.baoMingButton.userInteractionEnabled = NO;
    }
    
    else {
        
        self.activityDetailView.baoMingButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
        [self.activityDetailView.baoMingButton setTitleColor:[UIColor blueColor]
                                                    forState:UIControlStateNormal];
    }
    
    
    self.activityDetailView.titleLabel.text = self.model.content;
    self.activityDetailView.beginTimeLabel.text = self.model.start_time;
    self.activityDetailView.endTimeLabel.text = self.model.end_time;
    self.activityDetailView.addressLabel.text = self.model.store_address;
    [self.activityDetailView.centerNameButton setTitle:self.model.store_name forState:UIControlStateNormal];
    [self.activityDetailView.centerNameButton addTarget:self action:@selector(goCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(4, self.activityDetailView.frame.size.height, kScreenSize.width - 8, 300)];
    self.webView.delegate = self;
    self.webView.layer.masksToBounds = YES;
    self.webView.layer.cornerRadius = 5;
    self.webView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    self.webView.layer.borderWidth = 1;
    [self.webView loadHTMLString:self.model.remark baseURL:nil];
    
    [self.scroller addSubview:self.activityDetailView];
    [self.scroller addSubview:self.webView];
    [self.view addSubview:self.scroller];
    
    
}

#pragma mark - WebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{


   CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
   self.webView.frame = CGRectMake(4, self.activityDetailView.frame.size.height, kScreenSize.width - 8, height + 55);
   //关闭webView上下滑动
    UIScrollView *tempView=(UIScrollView *)[self.webView.subviews objectAtIndex:0];
    tempView.scrollEnabled=NO;
    self.scroller.contentSize = CGSizeMake(kScreenSize.width, height + self.activityDetailView.frame.size.height + 60);
    
}


#pragma mark - 点击事件
- (void)goCenter:(UIButton *)sender
{
    ODCenterDetailController *vc = [[ODCenterDetailController alloc] init];
    vc.storeId = self.storeId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)baoMingAction:(UIButton *)sender
{
    [self saveData];
  
}

-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
