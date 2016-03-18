//
//  ODOrderDetailView.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODOrderDetailView : UIView


@property(weak, nonatomic) IBOutlet UIButton *phoneButton;


@property(weak, nonatomic) IBOutlet UILabel *typeLabel;
@property(weak, nonatomic) IBOutlet UILabel *swapTypeLabel;
@property(weak, nonatomic) IBOutlet UIButton *userButtonView;
@property(weak, nonatomic) IBOutlet UILabel *nickLabel;
@property(weak, nonatomic) IBOutlet UIButton *contentButtonView;
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property(weak, nonatomic) IBOutlet UILabel *priceLabel;
@property(weak, nonatomic) IBOutlet UILabel *countLabel;
@property(weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressPhoneLabel;
@property(weak, nonatomic) IBOutlet UILabel *serviceTimeLabel;
@property(weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property(weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property(weak, nonatomic) IBOutlet UILabel *eightLabel;


@property(weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineThreeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineFourHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineFiveHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineSixHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineSevenHeightConstraint;







+ (instancetype)getView;

@end