//
//  ODPayView.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayView.h"

@implementation ODPayView

+(instancetype)getView
{
    ODPayView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODPayView" owner:nil options:nil] firstObject];
    
    
    
      view.userInteractionEnabled = YES;
  
      view.backgroundColor = [UIColor whiteColor];
      view.firstLineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
      view.secondLineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
      view.thirdLineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
      view.fourthLineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
     view.thirdLineLabelConstraint.constant = 0.5;
    view.fourthLineLabelConstraint.constant = 0.5;
    view.treasureImageView.hidden = YES;
    view.treasureLabel.hidden = YES;
    view.treasurePayButton.hidden = YES;
    view.fourthLineLabel.hidden = YES;

    return view;
    
    
    
    
}

@end
