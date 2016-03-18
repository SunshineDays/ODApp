//
//  ODOthersInformationController.m
//  ODApp
//
//  Created by Bracelet on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOthersInformationController.h"
#import "ODEvaluationController.h"
@interface ODOthersInformationController ()

@end

@implementation ODOthersInformationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isOther = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"个人中心";
    [self createRequest];
}

- (void)createRequest
{
    __weakSelf
    NSDictionary *parameter = @{@"open_id":self.open_id};
    [ODHttpTool getWithURL:ODUrlUserInfo parameters:parameter modelClass:[ODUserModel class] success:^(id model)
     {
        weakSelf.model = [model result];
        [weakSelf createCollectionView];
        [weakSelf.collectionView reloadData];
    }
                   failure:^(NSError *error)
     {
        
    }];
 }

- (void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - 20) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandFirstCell" bundle:nil] forCellWithReuseIdentifier:@"first"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODLandSecondCell" bundle:nil] forCellWithReuseIdentifier:@"second"];

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ODLandFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"first" forIndexPath:indexPath];
        
        [cell.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
        [cell.qrcodeImageView removeFromSuperview];
        [cell.centerImageView removeFromSuperview];
        cell.nickNameLabel.text = self.model.nick;
        cell.signatureLabel.text = self.model.sign;
        
        return cell;
    }
    else
    {
        ODLandSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"second" forIndexPath:indexPath];
        
        if (indexPath.section == 1)
        {
            cell.titleLabel.text = @"他的中心预约";
        }
        else if (indexPath.section == 2)
        {
            cell.titleLabel.text = @"他发表的话题";
        }
        else if (indexPath.section == 3)
        {
            cell.titleLabel.text = @"他发起的任务";
        }
        else if (indexPath.section == 4)
        {
            cell.titleLabel.text = @"他收到的评价";
        }
        return cell;        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
    }
    else if (indexPath.section == 1)
    {
        ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
        vc.open_id = self.model.open_id;
        vc.centerTitle = @"他的预约纪录";
//        vc.isOther = self.isOther;
        vc.isRefresh = YES;
        vc.isOther = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.section == 2)
    {
        ODOtherTopicViewController *vc = [[ODOtherTopicViewController alloc] init];
        vc.open_id = self.model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3)
    {
        ODOtherTaskController *vc = [[ODOtherTaskController alloc]init];
        vc.openId = self.model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 4)
    {
        ODEvaluationController *vc = [[ODEvaluationController alloc] init];
        vc.typeTitle = @"他收到的评价";
        vc.openId = self.model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(kScreenSize.width , 90);
    }
    else
    {
        return CGSizeMake(kScreenSize.width , 30);
    }
}

//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0,0);
}

//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 5);
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