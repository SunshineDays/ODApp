//
//  ODBazaarDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODHelp.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "ODBazaarDetailModel.h"
#import "ODBazaarDetailLayout.h"
#import "ODBazaarDetailCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface ODBazaarDetailViewController : ODBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,copy)NSString *task_id;
@property(nonatomic,strong)UIView *userView;
@property(nonatomic,strong)UIView *taskTopView;
@property(nonatomic,strong)UIView *taskBottomView;
@property(nonatomic,strong)UILabel *taskContentLabel;
@property(nonatomic,strong)UILabel *allLabel;
@property(nonatomic,strong)NSString *task_status;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton *taskButton;
@property(nonatomic,copy)NSString *open_id;
@end
