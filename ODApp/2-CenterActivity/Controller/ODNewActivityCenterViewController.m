//
//  ODNewActivityCenterViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODStorePlaceListModel.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "mjrefresh.h"
#import "ODActivitylistModel.h"
#import "ODNewActivityCell.h"
#import "ODPersonalCenterViewController.h"
#import "ODNewActivityCenterViewController.h"
#import "ODNewActivityDetailViewController.h"
#import "UITableViewRowAction+JZExtension.h"

@interface ODNewActivityCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) NSString *storeId;

/**
 *  从服务器获取到的数据
 */
@property(nonatomic, strong) NSArray *resultLists;
@end

@implementation ODNewActivityCenterViewController
static NSString *const cellId = @"newActivityCell";

Single_Implementation(ODNewActivityCenterViewController)

#pragma mark - lazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODTabBarHeight - ODNavigationHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODNewActivityCell class]) bundle:nil] forCellReuseIdentifier:cellId];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        tableView.rowHeight = 98;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"中心活动";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(placePre:) color:nil highColor:nil title:@"场地预约"];

    self.needRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ODNewActivityCenterViewController sharedODNewActivityCenterViewController].needRefresh = self.tabBarController.selectedIndex != 1;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - privateMethod

- (void)getDefaultCenterNameRequest{
    NSDictionary *parameter = @{@"show_type" : @"1",@"call_array":@"1"};
    __weakSelf;
    [ODHttpTool getWithURL:ODUrlOtherStoreList parameters:parameter modelClass:[ODStorePlaceListModel class] success:^(ODStorePlaceListModelResponse *model){
        ODStorePlaceListModel *listModel = model.result.firstObject;
        weakSelf.storeId = [@(listModel.id)stringValue];
        [weakSelf pushToPlace];
    }
                   failure:^(NSError *error) {
                   }];
}

- (void)requestData {
    __weakSelf

    [ODHttpTool getWithURL:ODUrlStoreActivityList parameters:@{} modelClass:[ODActivityListModel class] success:^(id json) {
                weakSelf.resultLists = [json result];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
            }
                   failure:^(NSError *error) {
                       [weakSelf.tableView.mj_header endRefreshing];
                   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODNewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.resultLists[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([ODUserInformation sharedODUserInformation].openID.length) {
        ODNewActivityDetailViewController *detailViewController = [[ODNewActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
        detailViewController.acitityId = [self.resultLists[indexPath.row] activity_id];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            ODPersonalCenterViewController *perV = [[ODPersonalCenterViewController alloc] init];
            [self presentViewController:perV animated:YES completion:nil];
        });
    }
}

#pragma mark - actions

- (void)placePre:(id)sender
{
    if (!self.storeId.length) {
        [self getDefaultCenterNameRequest];
    }
        else
    {
        [self pushToPlace];
    }
}

- (void)pushToPlace{
    
    if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }
    else {
        ODPrecontractViewController *vc = [[ODPrecontractViewController alloc] init];
        vc.storeId = [NSString stringWithFormat:@"%@", self.storeId];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

@end
