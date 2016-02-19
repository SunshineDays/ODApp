//
//  ODReleaseCell.h
//  ODApp
//
//  Created by 代征钏 on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODReleaseModel.h"
#import "UIImageView+WebCache.h"

@interface ODReleaseCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lovesLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) ODReleaseModel *model;


@end