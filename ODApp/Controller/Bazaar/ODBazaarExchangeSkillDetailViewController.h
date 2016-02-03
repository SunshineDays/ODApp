//
//  ODBazaarExchangeSkillDetailViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ODAPIManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ODBazaarExchangeSkillModel.h"
#import "ODHelp.h"
#import "ODOthersInformationController.h"
#import "ODOrderController.h"
#import "ODCollectionController.h"

@interface ODBazaarExchangeSkillDetailViewController : ODBaseViewController

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,copy)NSString *swap_id;
@property(nonatomic,strong)ODBazaarExchangeSkillModel *model;
@property(nonatomic,strong)UILabel *loveLabel;
@end