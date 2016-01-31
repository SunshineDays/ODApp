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
    
    self.navigationItem.title = @"我报名的活动";
  
    [self createCollectionView];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf downRefresh];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCollectionViewRequest];

}

- (void)downRefresh{

    [self getCollectionViewRequest];
}

- (void)getCollectionViewRequest
{

    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"open_id":openId,@"type":@"0"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyApplyActivityUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [weakSelf.noReusltLabel removeFromSuperview];
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [weakSelf.dataArray removeAllObjects];
            
            
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODMyApplyActivityModel *model = [[ODMyApplyActivityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
                
            }
            
            if (weakSelf.dataArray.count == 0) {
                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无活动" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:self.noReusltLabel];
            }
            else{
                [weakSelf.collectionView reloadData];
            }
            
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
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
    
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    
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
