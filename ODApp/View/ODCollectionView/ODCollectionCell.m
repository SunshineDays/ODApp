//
//  ODCollectionCell.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCollectionCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation ODCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.userImageButton.layer.masksToBounds = YES;
    self.userImageButton.layer.cornerRadius = 30;
    self.userImageButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.userImageButton.layer.borderWidth = 1;

    
    
}


- (void)setModel:(ODLikeModel *)model
{
    if (_model != model) {
        
        _model = model;
    }
    
    
    [self.userImageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal];
    self.schoolLabel.text = model.school_name;
    self.nameLabel.text = model.name;
    self.userImageButton.userInteractionEnabled = NO;
    NSString *gender = [NSString stringWithFormat:@"%@" , model.gender];
    if ([gender isEqualToString:@"0"]) {
        
        self.hisPictureView.image = [UIImage imageNamed:@"icon_woman"];
        
    }else{
        
          self.hisPictureView.image = [UIImage imageNamed:@"icon_man"];
    }
    
       
}




@end