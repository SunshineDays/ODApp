//
//  ODPersonalCenterCollectionController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODBazaarExchangeSkillModel.h"
#import "UIImageView+WebCache.h"
#import "ODHelp.h"
#import "ODCommunityShowPicViewController.h"
#import "MJRefresh.h"

@interface ODPersonalCenterCollectionController : ODBaseViewController 


@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic) NSInteger page;

@end
