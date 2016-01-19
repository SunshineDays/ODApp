//
//  ODMyApplyActivityController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyApplyActivityController.h"
#import "ODUserInformation.h"
@interface ODMyApplyActivityController ()

@end

@implementation ODMyApplyActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self navigationInit];
  
    [self createCollectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self downRefresh];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
      [self getCollectionViewRequest];
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

- (void)downRefresh{

    [self getCollectionViewRequest];
}

- (void)navigationInit
{
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"#f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160) / 2, 28, 160, 20) text:@"我报名的活动" font:17 alignment:@"center" color:@"#000000" alpha:1];
    [self.headView addSubview:label];
    
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28, 32, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
}

- (void)backButtonClick:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCollectionViewRequest
{

    NSString *openId = [ODUserInformation getData].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"open_id":openId,@"type":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyApplyActivityUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [self.dataArray removeAllObjects];
            
            
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODMyApplyActivityModel *model = [[ODMyApplyActivityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
                
            }
      
            [weakSelf.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
}

- (void)createCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ONMyApplyActivityCell" bundle:nil] forCellWithReuseIdentifier:kMyApplyActivityCellId];
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ONMyApplyActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyApplyActivityCellId forIndexPath:indexPath];
    ODMyApplyActivityModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.layer.cornerRadius = 7;
    [cell showDataWithModel:model];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return CGSizeMake(kScreenSize.width, 170);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ODActivityDetailController *vc = [[ODActivityDetailController alloc] init];
    ODMyApplyActivityModel *model = self.dataArray[indexPath.row];
    
    vc.activityId = [NSString stringWithFormat:@"%@", model.activity_id];
    vc.storeId = [NSString stringWithFormat:@"%@", model.store_id];
    
    NSString *openId = [ODUserInformation getData].openID;
    
    
    vc.openId = openId;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
