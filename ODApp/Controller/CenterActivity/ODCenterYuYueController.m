//
//  ODCenterYuYueController.m
//  ODApp
//
//  Created by zhz on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterYuYueController.h"
#import "ODTabBarController.h"
#import "CenterYuYueView.h"
#import "ODChoseCenterController.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODUserInformation.h"

#import "MBProgressHUD.h"

@interface ODCenterYuYueController ()<UITableViewDataSource , UITableViewDelegate , UITextViewDelegate , UITextFieldDelegate , UIPickerViewDataSource , UIPickerViewDelegate , MBProgressHUDDelegate>{

    MBProgressHUD *HUD;
}


@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) CenterYuYueView *yuYueView;


@property (nonatomic , assign) BOOL isComputer;
@property (nonatomic , assign) BOOL isTouYing;
@property (nonatomic , assign) BOOL isYinXiang;
@property (nonatomic , assign) BOOL isMai;

@property (nonatomic  , strong) UIPickerView *picker;

@property (nonatomic  , strong) UIButton *cancelButton;
@property (nonatomic  , strong) UIButton *queDingButton;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic  , assign) BOOL isBeginTime;

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
@property(nonatomic,strong)AFHTTPRequestOperationManager *timeManager;


@property (nonatomic , strong) NSMutableArray *timeArray;


@property (nonatomic , copy) NSString *beginTime;
@property (nonatomic , copy) NSString *endTime;
@property (nonatomic , copy) NSString *orderID;

@property (nonatomic , copy) NSString *openId;

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSArray *timeDataArray;
@property (nonatomic , strong) NSArray *keysArray;

@property (nonatomic , strong) NSString *dateStr;
@property (nonatomic , strong) NSString *timeStr;

@property (nonatomic , strong) NSString *btimeStr;
@property (nonatomic , strong) NSString *eimeStr;


@property (nonatomic , strong) NSString *yearStr;
@property (nonatomic , copy) NSString *start_datetime;

@end

@implementation ODCenterYuYueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.timeArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.timeDataArray = [[NSArray alloc] init];
    self.keysArray = [[NSArray alloc] init];

    self.isComputer = YES;
    self.isTouYing = YES;
    self.isYinXiang = YES;
    self.isMai = YES;
    
    
    self.dateStr = @"";
    self.timeStr = @"";
    self.btimeStr = @"";
    self.eimeStr = @"";
    self.yearStr = @"";
    self.start_datetime = @"";
    [self navigationInit];
    [self createTableView];
    
    
    self.openId = [ODUserInformation getData].openID;
    
    
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}


#pragma mark - 初始化
-(void)navigationInit
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 中心活动label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"场地预约" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    [self.headView addSubview:confirmButton];
    
    
    
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.yuYueView;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - 懒加载
- (CenterYuYueView *)yuYueView
{
    if (_yuYueView == nil) {
        self.yuYueView = [CenterYuYueView getView];
        
        
        [self.yuYueView.computerButton addTarget:self action:@selector(computerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.touYingButton addTarget:self action:@selector(touYingAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.yinXiangButton addTarget:self action:@selector(yinXiangAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.maiButton addTarget:self action:@selector(maiAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.yuYueButton addTarget:self action:@selector(yuYueAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.centerText addTarget:self action:@selector(choseCenter:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.phoneText addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuYueView.btimeText addTarget:self action:@selector(choseBeginTime:) forControlEvents:UIControlEventTouchUpInside];
        self.yuYueView.btimeText.tag = 111;
        [self.yuYueView.eTimeText addTarget:self action:@selector(choseBeginTime:) forControlEvents:UIControlEventTouchUpInside];
        self.yuYueView.eTimeText.tag = 222;

        [self.yuYueView.centerText  setTitle:self.centerName forState:UIControlStateNormal];
        [self.yuYueView.phoneText setTitle:self.phoneNumber forState:UIControlStateNormal];

        self.yuYueView.pursoseTextView.delegate=self;
        self.yuYueView.contentTextView.delegate=self;
    
        self.yuYueView.peopleNumberTextField.delegate = self;
     
        
    }
    return _yuYueView;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.yuYueView.peopleNumberTextField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 3) {
            return NO;
        }
    }
    
    return YES;
}




- (void)yuYueAction:(UIButton *)sender
{
    
    if ([self.yuYueView.btimeText.titleLabel.text isEqualToString:@"填写开始时间"]) {
        
        [self CreateProgressHudTitle:@"请选择时间" withAlpha:0.8f withAfterDelay:0.8f];
      

    }else if ([self.yuYueView.eTimeText.titleLabel.text isEqualToString:@"填写结束时间"]) {
        
        [self CreateProgressHudTitle:@"请填写结束时间" withAlpha:0.8f withAfterDelay:0.8f];
        
    }else if ([self.yuYueView.pursoseTextView.text isEqualToString:@""] || [self.yuYueView.pursoseTextView.text isEqualToString:@"输入活动目的"]) {
        
        [self CreateProgressHudTitle:@"请输入活动目的" withAlpha:0.8f withAfterDelay:0.8f];
        
    }else if ([self.yuYueView.contentTextView.text isEqualToString:@""] || [self.yuYueView.contentTextView.text isEqualToString:@"输入活动内容"]) {

        [self CreateProgressHudTitle:@"请输入活动内容" withAlpha:0.8f withAfterDelay:0.8f];
        
    }else if ([self.yuYueView.peopleNumberTextField.text isEqualToString:@""]) {
      
        [self CreateProgressHudTitle:@"请输入参加人数" withAlpha:0.8f withAfterDelay:0.8f];
    } else {
        
        [self getOrderId];

    }
    
}

- (void)getData
{
    self.timeManager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"store_id":self.storeId , @"start_datetime":self.start_datetime};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
      __weak typeof (self)weakSelf = self;
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/timeline";
    
    [self.timeManager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsPath = [path objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"TimeList.plist"];
        NSMutableArray *timesArray = [[NSMutableArray alloc ] init];
        
        if (responseObject) {
            
            [timesArray removeAllObjects];
            weakSelf.timeStr = @"";
            NSMutableDictionary *dic = responseObject[@"result"];
            weakSelf.keysArray = [dic allKeys];
            weakSelf.keysArray = [weakSelf.keysArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result == NSOrderedDescending;
            }];
            
            
            for (int i = 0; i < weakSelf.keysArray.count; i++) {
                NSMutableDictionary *dic1 = dic[weakSelf.keysArray[i]];
                NSString *str = dic1[@"date_left_str"];
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
                [dataDic setObject:str forKey:@"date"];
                NSMutableArray *timeArray = dic1[@"cao"];
                NSMutableArray *dataTimeArray = [[NSMutableArray alloc] init];
                for (NSMutableDictionary *dic2 in timeArray) {
                    
                NSInteger status = [dic2[@"status"] integerValue];
                    
                if (status == 1) {
                        NSString *time = dic2[@"time"];
                        
                        [dataTimeArray addObject:time];
                        
                    }else {
                        ;
                    }
                    
                }
                
                [dataDic setObject:dataTimeArray forKey:@"time"];
                
                [timesArray addObject:dataDic];
                
                
            }
            
            [timesArray writeToFile:plistPath atomically:YES];
            
            
        }
        
        weakSelf.dataArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        weakSelf.timeDataArray = [[weakSelf.dataArray objectAtIndex:0] objectForKey:@"time"];
        
        
        weakSelf.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 150, kScreenSize.width, 150)];
        weakSelf.picker.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        weakSelf.picker.delegate = weakSelf;
        weakSelf.picker.dataSource = weakSelf;
        
        weakSelf.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        weakSelf.cancelButton.frame = CGRectMake(0, kScreenSize.height - 180, 50, 30);
        [weakSelf.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        weakSelf.cancelButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        [weakSelf.cancelButton addTarget:weakSelf action:@selector(quXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
        weakSelf.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        
        weakSelf.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, kScreenSize.height - 180, kScreenSize.width - 100, 30)];
        weakSelf.timeLabel.text = @"选择时间";
        weakSelf.timeLabel.font = [UIFont systemFontOfSize:20];
        weakSelf.timeLabel.textAlignment = NSTextAlignmentCenter;
        weakSelf.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        
        
        
        weakSelf.queDingButton = [UIButton buttonWithType:UIButtonTypeSystem];
        weakSelf.queDingButton.frame = CGRectMake(kScreenSize.width - 50, kScreenSize.height - 180, 50, 30);
        [weakSelf.queDingButton setTitle:@"确定" forState:UIControlStateNormal];
        weakSelf.queDingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        [weakSelf.queDingButton addTarget:weakSelf action:@selector(queDingAction:) forControlEvents:UIControlEventTouchUpInside];
        weakSelf.queDingButton.titleLabel.font = [UIFont systemFontOfSize:17];
        
        
        if (weakSelf.isBeginTime) {
            
            weakSelf.yuYueView.btimeText.userInteractionEnabled = NO;
            weakSelf.yuYueView.eTimeText.userInteractionEnabled = NO;
            [weakSelf.view addSubview: weakSelf.queDingButton];
            [weakSelf.view addSubview: weakSelf.cancelButton];
             [weakSelf.view addSubview: weakSelf.timeLabel];
            [weakSelf.view addSubview:weakSelf.picker];
            
            
        }else{
            if ([weakSelf.start_datetime isEqualToString:@""]) {
                
                
                [self CreateProgressHudTitle:@"请选择开始时间" withAlpha:0.8f withAfterDelay:0.8f];
                
            }else{
                
                
                weakSelf.yuYueView.btimeText.userInteractionEnabled = NO;
                weakSelf.yuYueView.eTimeText.userInteractionEnabled = NO;
                [weakSelf.view addSubview: weakSelf.queDingButton];
                [weakSelf.view addSubview: weakSelf.cancelButton];
                 [weakSelf.view addSubview: weakSelf.timeLabel];
                [weakSelf.view addSubview:weakSelf.picker];
                
            }
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}



#pragma mark - 请求数据
- (void)getOrderId
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.beginTime = [self.yearStr stringByAppendingString:@" "];
    self.beginTime = [self.beginTime stringByAppendingString:self.btimeStr];
    self.endTime = [self.yearStr stringByAppendingString:@" "];
    self.endTime = [self.endTime stringByAppendingString:self.eimeStr];
    
    NSDictionary *parameter = @{@"start_datetime":self.beginTime , @" end_datetime":self.endTime , @"store_id":self.storeId , @"open_id":self.openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/create/order";
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            NSMutableDictionary *dic = responseObject[@"result"];
            self.orderID = [NSString stringWithFormat:@"%@" , dic[@"order_id"]];
            [self saveData];
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            [self CreateProgressHudTitle:responseObject[@"message"] withAlpha:1.0f withAfterDelay:1.0f];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
    
}

- (void)saveData
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSString *computerY = @"";
    NSString *touYingY = @"";
    NSString *yinXingY = @"";
    NSString *maiY = @"";
    if (!self.isComputer) {
        computerY = @"1";
    }
    if (!self.isTouYing) {
        touYingY = @"2";
    }
    if (!self.isYinXiang) {
        yinXingY = @"3";
    }
    if (!self.isMai) {
        maiY = @"4";
    }
    
    NSString *equipment = [NSString stringWithFormat:@"%@,%@,%@,%@" , computerY , touYingY , yinXingY , maiY];
    NSDictionary *parameter = @{@"start_datetime":self.beginTime , @"end_datetime":self.endTime , @"store_id":self.storeId , @"order_id":self.orderID ,@"purpose":self.yuYueView.pursoseTextView.text ,@"content":self.yuYueView.contentTextView.text ,@"people_num":self.yuYueView.peopleNumberTextField.text ,@"remark":@"无" ,@"devices":equipment ,@"open_id":self.openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/confirm/order";
    [self.managers GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            [self CreateProgressHudTitle:@"感谢您的预约请等待审核" withAlpha:1.0f withAfterDelay:1.0f];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            [self CreateProgressHudTitle:responseObject[@"message"] withAlpha:1.0f withAfterDelay:1.0f];
        }
  
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
    
}

#pragma mark - 创建提示信息
- (void)CreateProgressHudTitle:(NSString *)title withAlpha:(float)alpha withAfterDelay:(float)afterDelay
{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.delegate  = self;
    
    HUD.color = [UIColor colorWithHexString:@"#8e8e8e" alpha:alpha];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = title;
    HUD.margin = 8.f;
    HUD.yOffset = 150.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:afterDelay];
   
}

#pragma mark - 点击事件
-(void)fanhui:(UIButton *)sender
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"是否退出预约" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.delegate = self;
    alter.tag = 111;
    [alter show];
    
}
#pragma mark - alterviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111)
    {
        if (buttonIndex == 0) {
            ;
        }else {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}


- (void)choseBeginTime:(UIButton *)sender
{
    
    
    if (sender.tag == 111) {
        
        self.isBeginTime = YES;
        self.start_datetime = @"";
        [self getData];
        
        
    }else if (sender.tag == 222) {
        
        
        self.isBeginTime = NO;
        [self getData];
        
        
    }
    
    
}

#pragma mark - UIPickviewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少哥列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return self.dataArray.count;
        
        
    }
    
    else {
        return self.timeDataArray.count;
    }
}

// UIPickerViewDelegate中定义的方法，该方法返回NSString将作为UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [[self.dataArray objectAtIndex:row] objectForKey:@"date"];
            break;
        case 1:
            return self.timeDataArray[row];
            break;
        default:
            return nil;
            break;
    }
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            
            self.timeDataArray = [[self.dataArray objectAtIndex:row] objectForKey:@"time"];
            self.dateStr = [[self.dataArray objectAtIndex:row] objectForKey:@"date"];
            self.yearStr = self.keysArray[row];
            [pickerView reloadComponent:1];
            break;
            
        case 1:
            
            self.timeStr = self.timeDataArray[row];
            break;
            
    }
  
}

- (void)quXiaoAction:(UIButton *)sender
{
    if ([self.yearStr isEqualToString:@""]) {
        self.yearStr = self.keysArray[0];
    }
    
    NSString *beginTime = [self.yearStr stringByAppendingString:@" "];
    beginTime = [beginTime stringByAppendingString:self.btimeStr];
    self.start_datetime = beginTime;
    
    self.yuYueView.btimeText.userInteractionEnabled = YES;
    self.yuYueView.eTimeText.userInteractionEnabled = YES;
    
    [self.picker removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.queDingButton removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    
    
    
}


- (void)queDingAction:(UIButton *)sender
{
    
    
    
    if ([self.yearStr isEqualToString:@""]) {
        self.yearStr = self.keysArray[0];
    }
    
    
    
    if (self.isBeginTime) {
        
        if ([self.dateStr isEqualToString:@""]) {
            self.dateStr = [[self.dataArray objectAtIndex:0] objectForKey:@"date"];
        }
        if ([self.timeStr isEqualToString:@""]) {
            self.timeDataArray = [[self.dataArray objectAtIndex:0] objectForKey:@"time"];
            self.timeStr = self.timeDataArray[0];
        }
        self.btimeStr = self.timeStr;
        NSString *time = [self.dateStr stringByAppendingString:self.timeStr];
        
        [self.yuYueView.btimeText setTitle:time forState:UIControlStateNormal];
        [self.yuYueView.eTimeText setTitle:@"填写结束时间" forState:UIControlStateNormal];
        self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        if (iPhone4_4S || iPhone5_5s) {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:12];
            
            
        }else if (iPhone6_6s) {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:14];
            
        }else {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:15];
            
            
        }
        
        NSString *beginTime = [self.yearStr stringByAppendingString:@" "];
        beginTime = [beginTime stringByAppendingString:self.btimeStr];
        self.start_datetime = beginTime;
        
        
        
    }else {
        
        
        if ([self.dateStr isEqualToString:@""]) {
            self.dateStr = [[self.dataArray objectAtIndex:0] objectForKey:@"date"];
        }
        if ([self.timeStr isEqualToString:@""]) {
            self.timeDataArray = [[self.dataArray objectAtIndex:0] objectForKey:@"time"];
            self.timeStr = self.timeDataArray[0];
        }
        
        self.eimeStr = self.timeStr;
        NSString *time = [self.dateStr stringByAppendingString:self.timeStr];
        
        [self.yuYueView.eTimeText setTitle:time forState:UIControlStateNormal];
        
        
        if (iPhone4_4S || iPhone5_5s) {
            self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:12];
            
        }else if (iPhone6_6s) {
            
            self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:15];
        }else {
            
            self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:15];
            
        }
        
        
    }
    
    
    
    self.yuYueView.btimeText.userInteractionEnabled = YES;
    self.yuYueView.eTimeText.userInteractionEnabled = YES;

    [self.picker removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.queDingButton removeFromSuperview];
    [self.timeLabel removeFromSuperview];
}



- (void)choseCenter:(UIButton *)sender
{
    ODChoseCenterController *vc = [[ODChoseCenterController alloc] init];
    
    
        vc.storeCenterNameBlock = ^(NSString *name , NSString *storeId , NSInteger storeNumber){
        
        [self.yuYueView.centerText setTitle:name forState:UIControlStateNormal];
            
            
            if ([self.storeId isEqualToString:storeId]) {
                
                ;

            }else{
                self.storeId = storeId;
                self.start_datetime = @"";
                
                [self.yuYueView.btimeText setTitle:@"填写开始时间" forState:UIControlStateNormal];
                [self.yuYueView.eTimeText setTitle:@"填写结束时间" forState:UIControlStateNormal];
                self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:15];
                self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            
            
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)phoneAction:(UITapGestureRecognizer *)sender
{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.yuYueView.phoneText.titleLabel.text];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


- (void)computerAction:(UIButton *)sender
{
    
    if (self.isComputer) {
        [self.yuYueView.computerButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.computerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    self.isComputer = !self.isComputer;
    
    
}

- (void)touYingAction:(UIButton *)sender
{
    
    if (self.isTouYing) {
        [self.yuYueView.touYingButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.touYingButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    self.isTouYing = !self.isTouYing;
    
    
}

- (void)yinXiangAction:(UIButton *)sender
{
    
    if (self.isYinXiang) {
        [self.yuYueView.yinXiangButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.yinXiangButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    self.isYinXiang = !self.isYinXiang;
    
    
}

- (void)maiAction:(UIButton *)sender
{
    
    if (self.isMai) {
        [self.yuYueView.maiButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.maiButton setImage:[UIImage imageNamed:@"."] forState:UIControlStateNormal];
        
    }
    self.isMai = !self.isMai;
    
    
}


#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.yuYueView.pursoseTextView) {
        if ([textView.text isEqualToString:NSLocalizedString(@"输入活动目的", nil)]) {
            self.yuYueView.pursoseTextView.text=NSLocalizedString(@"", nil);
            self.yuYueView.pursoseTextView.textColor = [UIColor blackColor];
        }else{
            ;
        }

    }else if (textView == self.yuYueView.contentTextView) {
        if ([textView.text isEqualToString:NSLocalizedString(@"输入活动内容", nil)]) {
            self.yuYueView.contentTextView.text=NSLocalizedString(@"", nil);
            self.yuYueView.contentTextView.textColor = [UIColor blackColor];
        }else{
            ;
        }
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == self.yuYueView.pursoseTextView) {
       
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;

        }
    }
    
    if (textView == self.yuYueView.contentTextView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 100) {
            return NO;
        }
    }
    
    return YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor = [UIColor lightGrayColor];
        if (textView == self.yuYueView.pursoseTextView) {
            textView.text=NSLocalizedString(@"输入活动目的", nil);
            
        }else{
            textView.text=NSLocalizedString(@"输入活动内容", nil);
        }
    }
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
