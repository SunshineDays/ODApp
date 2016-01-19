//
//  ODCenterPactureController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCenterPactureController.h"

@interface ODCenterPactureController ()

@property(nonatomic , strong) UIView *headView;



@end

@implementation ODCenterPactureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self navigationInit];
    
    
   
    
    
}

- (void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 初始化导航
-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 选择中心label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 150) / 2, 28, 150, 20) text:self.activityName font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button
<<<<<<< HEAD
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-10, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
=======
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
>>>>>>> ab9b6b0ccedcaaee159908d6427c4c8f0fa3d1a6
    [self.headView addSubview:confirmButton];
    
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64 - 55)];
    NSString *openId = @"766148455eed214ed1f8";
    NSString *newWebUrl = [self.webUrl stringByAppendingString:openId];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:newWebUrl]];
    [self.view addSubview:web];
    [web loadRequest:request];

    
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
