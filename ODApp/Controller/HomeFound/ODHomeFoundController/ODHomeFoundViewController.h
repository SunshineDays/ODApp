//
//  ODHomeFoundViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "ODClassMethod.h"
#import "ODAPIManager.h"
#import "ODCommumityViewController.h"
#import "ODCenterActivityViewController.h"
#import "ODCenterYuYueController.h"
#import "ODTabBarController.h"
#import "ODLazyViewController.h"
#import "ODAPIManager.h"
#import "ODCommunityModel.h"
#import "ODcommunityCollectionCell.h"
#import "ODCenterIntroduceController.h"
#import "ODhomeViewCollectionReusableView.h"
#import "ODOthersInformationController.h"
#import "ODPersonalCenterViewController.h"
#import "ODHomeFoundFooterView.h"
#import "ODLocationController.h"
#import "ODFindJobController.h"
#import "ODNewActivityDetailViewController.h"

@interface ODHomeFoundViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong)UIButton *locationButton;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong)ODhomeViewCollectionReusableView *rsusableView;
@property (nonatomic ,strong)ODHomeFoundFooterView *footerView;

@property (nonatomic, strong) ODCommunityModel *model;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong)AFHTTPRequestOperationManager *managers;

//滚动窗口数组
@property (nonatomic, strong)NSArray *pictureArray;
@property (nonatomic, strong)NSArray *pictureIdArray;

//最新话题数组
@property (nonatomic, strong)NSMutableArray *dataArray;




@end
