//
//  ODTakeAwayViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODTakeAwayViewController.h"

#import <MJRefresh.h>
#import "ODTakeOutBannerModel.h"
#import "ODTakeAwayModel.h"
#import "ODTakeAwayCell.h"
#import "ODTakeAwayHeaderView.h"

#import "ODTakeAwayDetailController.h"

@interface ODTakeAwayViewController () <UITableViewDataSource, UITableViewDelegate,
                                        ODTakeAwayHeaderViewDelegate>

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic, strong) NSNumber *page;
/** 类型 */
@property (nonatomic, strong) NSNumber *type;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 头部控件 */
@property (nonatomic, weak) ODTakeAwayHeaderView *headerView;

@end

@implementation ODTakeAwayViewController

#pragma mark - 懒加载
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

// 循环cell标识
static NSString * const takeAwayCellId = @"ODTakeAwayViewCell";

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化scrollView
    [self setupScrollView];
    
    // 初始化表格
    [self setupTableView];
    
    // 初始化headerView
    [self setupHeaderView];
    
    // 加载广告页
    [self loadNewBanners];
    
    // 初始化刷新控件
    [self setupScrollViewRefresh];
}

#pragma mark - 初始化方法
/**
 *  初始化scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.navigationItem.title = @"订外卖";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.scrollView.bounds
                                                          style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(163, 0, 0, 0);
    
    self.type = self.page = @1;
    
    // rowHeight
    tableView.rowHeight = 90;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODTakeAwayCell class]) bundle:nil] forCellReuseIdentifier:takeAwayCellId];
}

/**
 *  初始化headerView
 */
- (void)setupHeaderView
{
    ODTakeAwayHeaderView *headerView = [ODTakeAwayHeaderView headerView];
    [headerView sizeToFit];
    // 设置代理
    headerView.delegate = self;
    [self.scrollView addSubview:headerView];
    self.headerView = headerView;
}

/**
 *  设置刷新控件
 */
- (void)setupScrollViewRefresh
{
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTakeOuts)];
    [self.scrollView.mj_header beginRefreshing];
    self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTakeOuts)];
    self.scrollView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - UITableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTakeAwayCell *cell = [tableView dequeueReusableCellWithIdentifier:takeAwayCellId];
    cell.datas = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
    // 点击方法
    
    ODTakeAwayModel *model = self.datas[indexPath.row];
    ODTakeAwayDetailController *vc = [[ODTakeAwayDetailController alloc] init];
    vc.product_id = [NSString stringWithFormat:@"%@", model.product_id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ODTakeAwayHeaderView 代理方法
- (void)headerView:(ODTakeAwayHeaderView *)headerView didClickedMenuButton:(NSInteger)index
{
    self.type = @(index);
    self.page = @1;
    [self loadNewTakeOuts];
}

#pragma mark - 事件方法
- (void)loadNewBanners
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"position"] = @"9";
    params[@"store_id"] = @"0";
    __weakSelf
    [ODHttpTool getWithURL:ODUrlOtherBanner parameters:params modelClass:[ODTakeOutBannerModel class] success:^(id model) {
        weakSelf.headerView.banners = [model result];
    } failure:^(NSError *error) {
    }];
}

- (void)loadNewTakeOuts
{
    // 结束上拉加载
    [self.scrollView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = [NSString stringWithFormat:@"%@", self.type];
    params[@"page"] = [NSString stringWithFormat:@"%@", self.page];
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutList parameters:params modelClass:[ODTakeAwayModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        // 清空所有数据
        [weakSelf.datas removeAllObjects];
        
        NSArray *newDatas = [model result];
        [weakSelf.datas addObjectsFromArray:newDatas];
        [weakSelf.tableView reloadData];
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf checkFooterState:newDatas.count];
        // 重新设置 page = 1
        weakSelf.page = @1;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTakeOuts
{
    // 结束下拉刷新
    [self.scrollView.mj_header endRefreshing];
    // 取出页码
    NSNumber *currentPage = @([self.page integerValue] + 1);
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = [NSString stringWithFormat:@"%@", self.type];
    params[@"page"] = [NSString stringWithFormat:@"%@", currentPage];
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutList parameters:params modelClass:[ODTakeAwayModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        NSArray *moreTakeOuts = [model result];
        [weakSelf.datas addObjectsFromArray:moreTakeOuts];
        [weakSelf.tableView reloadData];
        [weakSelf checkFooterState:moreTakeOuts.count];
        // 请求成功后才赋值页码
        weakSelf.page = currentPage;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        weakSelf.page = @([weakSelf.page integerValue] - 1);
        [weakSelf.scrollView.mj_footer endRefreshing];
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState:(NSUInteger)count
{
    if (count < 20) { // 全部数据已经加载完毕
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.scrollView.mj_footer endRefreshing];
    }
}

@end
