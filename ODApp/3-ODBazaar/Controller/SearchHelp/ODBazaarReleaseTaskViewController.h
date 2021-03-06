//
//  ODBazaarReleaseTaskViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODBazaarReleaseRewardViewController.h"
#import "ODBazaarViewController.h"


@interface ODBazaarReleaseTaskViewController : ODBaseViewController <UITextViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITextView *titleTextView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *taskDetailTextView;
@property(nonatomic, strong) UILabel *taskDetailLabel;
@property(nonatomic, strong) UILabel *startDateLabel;
@property(nonatomic, strong) UILabel *endDateLabel;
@property(nonatomic, strong) UILabel *startTimeLabel;
@property(nonatomic, strong) UILabel *endTimeLabel;
@property(nonatomic, strong) UILabel *taskRewardLabel;
@property(nonatomic, strong) UIView *backPickerView;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, strong) NSString *reward_id;
@property(nonatomic, copy) void(^myBlock)(NSString *refresh);
@property(nonatomic, copy) NSString *currentDateStr;
@property(nonatomic, assign) BOOL isJob;
@property(nonatomic, assign) BOOL isBazaar;

@end
