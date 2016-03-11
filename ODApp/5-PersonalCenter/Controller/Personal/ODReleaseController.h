//
//  ODReleaseController.h
//  ODApp
//
//  Created by Bracelet on 16/2/18.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODReleaseCell.h"
#import "ODReleaseModel.h"
#import "MJRefresh.h"
#import "ODBazaarReleaseSkillViewController.h"

@interface ODReleaseController : ODBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  交易ID
 */
@property(nonatomic, copy) NSString *swap_id;

@end
