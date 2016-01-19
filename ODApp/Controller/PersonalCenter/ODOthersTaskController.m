//
//  ODOthersTaskController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOthersTaskController.h"

@interface ODOthersTaskController ()

@end

@implementation ODOthersTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.FirstDataArray = [[NSMutableArray alloc] init];
    
    [self navigationController];
    [self createRequest];
}

-(void)navigationInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 180) / 2, 28, 180, 20) text:@"他发表的任务" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-10, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
    
}

- (void)fanhui:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createRequest{

    NSString *countNumber = [NSString stringWithFormat:@"%ld" , (long)self.firstPage];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"suggest":@"0", @"task_status":self.type, @"page":countNumber, @"my":@"1" , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/task/list";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([countNumber isEqualToString:@"1"]) {
            [self.FirstDataArray removeAllObjects];
            
        }
        
        
        
        if (responseObject) {
            
            
            NSDictionary *result = responseObject[@"result"];
            NSArray *tasks = result[@"tasks"];
            
            
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [self.FirstDataArray addObject:model];
            }
            
            
            
        }
        
        
        [self.firstCollectionView.mj_header endRefreshing];
        [self.firstCollectionView.mj_footer endRefreshing];
        [self.firstCollectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    ODTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.userImageView.layer.masksToBounds = YES;
    cell.userImageView.layer.cornerRadius = 30;
    cell.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.userImageView.layer.borderWidth = 1;
    

    ODBazaarModel *model = self.FirstDataArray[indexPath.row];
    
    
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    cell.nickLabel.text = model.user_nick;
    cell.titleLabel.text = model.title;
    cell.contentLabel.text = model.content;
    
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.task_status];
    
    if ([status isEqualToString:@"1"]) {
        cell.typeLabel.text = @"等待派单";
        cell.typeLabel.textColor = [UIColor redColor];
        
    }else if ([status isEqualToString:@"2"]) {
        
        cell.typeLabel.text = @"进行中";
    }else if ([status isEqualToString:@"3"]) {
        
        cell.typeLabel.text = @"交付";
    }else if ([status isEqualToString:@"4"]) {
        
        cell.typeLabel.text = @"确认完成";
    }else if ([status isEqualToString:@"-1"]) {
        
        cell.typeLabel.text = @"违规";
    }else if ([status isEqualToString:@"-2"]) {
        
        cell.typeLabel.text = @"过期任务";
        cell.typeLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"0"]) {
        
        cell.typeLabel.text = @"无效";
    }
      
    //设置Label显示不同大小的字体
    NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 5)];
    cell.timeLabel.attributedText = noteStr;
        
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.FirstDataArray.count;

    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
    ODBazaarModel *model = self.FirstDataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
    bazaarDetail.task_status = [NSString stringWithFormat:@"%@",model.task_status];
    [self.navigationController pushViewController:bazaarDetail animated:YES];
    
}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 140);
    
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
    return CGSizeMake(0, 0);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
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