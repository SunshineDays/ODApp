//
//  ODInformationController.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODInformationController.h"
#import "ODInformationView.h"
#import "ODUserSignatureController.h"
#import "ODUserNickNameController.h"
#import "ODUserGenderController.h"
#import "ODBindingMobileController.h"
#import "ODTabBarController.h"
#import "ODUser.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "UIImageView+WebCache.h"
#import "ODChangePassWordController.h"

@interface ODInformationController ()<UITableViewDataSource , UITableViewDelegate ,UIImagePickerControllerDelegate , UIActionSheetDelegate , UINavigationControllerDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) ODInformationView *informationView;
@property (nonatomic , strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) AFHTTPRequestOperationManager *managers;
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , strong) UIImagePickerController *imagePicker;
@property (nonatomic , copy) NSString *imgsString;

@end

@implementation ODInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
 
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    self.navigationItem.title = @"个人中心";
    
    
}


#pragma mark - 请求数据
- (void)getData
{
    [self.dataArray removeAllObjects];
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserInfo  parameters:@{} modelClass:[ODUser class] success:^(id model) {
        ODUser *user = [model result];
        [weakSelf.dataArray addObject:user];
        
        [weakSelf createTableView];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}



- (void)createTableView
{
   
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 50) style:UITableViewStylePlain];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.userInteractionEnabled = YES;
        
         self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.informationView = [ODInformationView getView];
        self.informationView.userInteractionEnabled = YES;
        self.tableView.tableHeaderView = self.informationView;
        [self.view addSubview:self.tableView];
    }
    
    ODUser *model = self.dataArray[0];
    
    
      [self.informationView.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar]];
    
    
    UITapGestureRecognizer *pictMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picAction)];
    [self.informationView.userImageView addGestureRecognizer:pictMap];
    
    
    
    self.informationView.userImageView.layer.masksToBounds = YES;
    self.informationView.userImageView.layer.cornerRadius = 47.5;
    self.informationView.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.informationView.userImageView.layer.borderWidth = 1;

    
    if ([model.sign isEqualToString:@""]) {
        self.informationView.signatureLabel.text = @"未设置签名";
    }else{
        
        
        self.informationView.signatureLabel.text = model.sign;
        
    }

    UITapGestureRecognizer *signatureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signatureAction)];
    [self.informationView.signatureImageView addGestureRecognizer:signatureTap];

    
    
    if ([model.nick isEqualToString:@""]) {
        self.informationView.nickNameLabel.text = @"未设置昵称";
    }else{
        self.informationView.nickNameLabel.text = model.nick;
        
    }

    UITapGestureRecognizer *nickNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameAction)];
    [self.informationView.nickNameImageView addGestureRecognizer:nickNameTap];
    
    NSString *gender = [NSString stringWithFormat:@"%ld" , (long)model.gender];

    
    if ([gender isEqualToString:@"1"]) {
        self.informationView.genderLabel.text = @"男";
    }else if ([gender isEqualToString:@"2"]){
        self.informationView.genderLabel.text = @"女";
        
    }

    
    UITapGestureRecognizer *genderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderAction)];
    [self.informationView.genderImageView addGestureRecognizer:genderTap];
    
    
    self.informationView.phoneLabel.text = model.mobile;
    
//    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction)];
//    [self.informationView.phoneImageView addGestureRecognizer:phoneTap];
//    
    
    UITapGestureRecognizer *passWordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passWordAction)];
    [self.informationView.passWordImageView addGestureRecognizer:passWordTap];

    [self.informationView.codeImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.qrcode]];
    
    
    
}

#pragma mark - 点击事件
- (void)signatureAction
{
    
    ODUserSignatureController *vc = [[ODUserSignatureController alloc] init];
    
  
    vc.signature =self.informationView.signatureLabel.text;
    
    vc.getTextBlock = ^(NSString *text){
        
     
        if ([text isEqualToString:@""] || [text isEqualToString:@"请输入签名"]) {
            self.informationView.signatureLabel.text = [NSString stringWithFormat:@"未设置签名"];
        }else{
            
            self.informationView.signatureLabel.text = text;
            
        }

    };

    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)nickNameAction
{
    
    ODUserNickNameController *vc = [[ODUserNickNameController alloc] init];
    
  
    vc.nickName =  self.informationView.nickNameLabel.text;
   
    vc.getTextBlock = ^(NSString *text){
        
        
        if ([text isEqualToString:@""]||[text isEqualToString:@"请输入昵称"]) {
            self.informationView.nickNameLabel.text = [NSString stringWithFormat:@"未设置昵称"];
        }else{
            
            self.informationView.nickNameLabel.text = text;
            
        }
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)genderAction
{
    
    ODUserGenderController *vc = [[ODUserGenderController alloc] init];
     
    vc.getTextBlock = ^(NSString *text){
        
    if ([text isEqualToString:@"1"]) {
            self.informationView.genderLabel.text = @"男";
        }else if ([text isEqualToString:@"2"]){
            self.informationView.genderLabel.text = @"女";
            
        }
      };

    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)phoneAction
{
    
    ODBindingMobileController *vc = [[ODBindingMobileController alloc] init];
   
    
    
    vc.getTextBlock = ^(NSString *text){
        
        
    self.informationView.phoneLabel.text = text;
   
        
    };


    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)passWordAction
{
    
    ODChangePassWordController *vc = [[ODChangePassWordController alloc] init];
    ODUser *model = self.dataArray[0];
    
    vc.phoneNumber = model.mobile;
  
    vc.topTitle = @"修改密码";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)picAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }
            else {
                
                
                [ODProgressHUD showInfoWithStatus:@"您当前的照相机不可用"];
                
                
            }
            break;
        case 1:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
            break;
        default:
            break;
    }
}

// 自己处理cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击确定之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        
        self.image = info[UIImagePickerControllerEditedImage];
        
        self.informationView.userImageView.image = self.image;
        
        
        //设置image的尺寸
        CGSize imagesize = self.image.size;
        
        imagesize.height = 200;
        imagesize.width = 200;
        
        //对图片大小进行压缩--
        UIImage *image1 = [self imageWithImage:self.image scaledToSize:imagesize];
        //图片转化为data
        NSData *imageData;
        imageData = UIImagePNGRepresentation(image1);
        NSString *str = @"data:image/jpeg;base64,";
        NSString *strData = [str stringByAppendingString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        
        NSDictionary *parameter = @{@"File":strData};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        
            
        [self pushImageWithUrl:kGetImageDataUrl parameter:signParameter];

        
    }
}


#pragma mark - 压缩照片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



#pragma mark - 请求数据
-(void)pushImageWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
    __weak typeof (self)weakSelf = self;
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSString *str = result[@"File"];
           
            weakSelf.imgsString = str;
   
            [weakSelf saveImge];

        }
  
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       
    }];
}


- (void)saveImge
{
    __weak typeof (self)weakSelf = self;
    [ODHttpTool getWithURL:ODUrlUserChange parameters:@{} modelClass:[NSObject class] success:^(id model)
     {
        [weakSelf.imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
                   failure:^(NSError *error)
    {
        
    }];
}


#pragma mark - UITableViewDelegate
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


@end
