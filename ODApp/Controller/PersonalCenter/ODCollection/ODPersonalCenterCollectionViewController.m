//
//  ODPersonalCenterCollectionViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPersonalCenterCollectionViewController.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"

@interface ODPersonalCenterCollectionViewController ()

@end

@implementation ODPersonalCenterCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page = 1;
    [self createRequest];
    [self createCollectionView];
    [self joiningTogetherParmeters];
    
    self.navigationItem.title = @"我的收藏";
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

}

-(void)loadMoreData
{
    self.page ++;
    NSDictionary *parameter = @{@"type":@"4",@"page":[NSString stringWithFormat:@"%ld",self.page],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCollectionUrl parameter:signParameter];
}
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.page = 1;
    NSDictionary *parameter = @{@"type":@"4",@"page":[NSString stringWithFormat:@"%ld",self.page],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    NSLog(@"%@",signParameter);
    [self downLoadDataWithUrl:kCollectionUrl parameter:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weakSelf
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODBazaarExchangeSkillModel *model = [[ODBazaarExchangeSkillModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
    }];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenSize.width,kScreenSize.height-64) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    cell.nickLabel.text = model.user[@"nick"];
    [cell showDatasWithModel:model];
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs_small.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs_small.count==4) {
            for (NSInteger i = 0; i < model.imgs_small.count; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%2), (width+5)*(i/2), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = 2*width+5;
        }else{
            for (NSInteger i = 0;i < model.imgs_small.count ; i++) {
                NSDictionary *dict = model.imgs_small[i];
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%3), (width+5)*(i/3), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.picViewConstraintHeight.constant = width+(width+5)*(model.imgs_small.count/3);
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.picViewConstraintHeight.constant = 0;
    }
    
    return cell;
}

-(void)imageButtonClicked:(UIButton *)button
{
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = model.imgs_small;
    picController.selectedIndex = button.tag-10*indexPath.row;
    picController.skill = @"skill";
    [self.navigationController pushViewController:picController animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc]init];
    detailControler.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
    NSLog(@"%@",detailControler.swap_id);
    [self.navigationController pushViewController:detailControler animated:YES];
    
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODBazaarExchangeSkillModel *)model
{
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs_small.count==0) {
        return 180;
    }else if (model.imgs_small.count>0&&model.imgs_small.count<4){
        return 180+width;
    }else if (model.imgs_small.count>=4&&model.imgs_small.count<7){
        return 180+2*width+5;
    }else if (model.imgs_small.count>=7&&model.imgs_small.count<9){
        return 180+3*width+10;
    }else{
        return 180+3*width+10;
    }
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