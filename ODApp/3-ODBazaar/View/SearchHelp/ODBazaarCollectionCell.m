//
//  ODBazaarCollectionCell.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarCollectionCell.h"

@implementation ODBazaarCollectionCell

- (void)awakeFromNib {
    
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 24;
    self.titleLabel.textColor = [UIColor colorGloomyColor];
    self.contentLabel.textColor = [UIColor colorGraynessColor];
    self.nameLabel.textColor = [UIColor blackColor];
    self.timeLabel.textColor = [UIColor colorRedColor];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.textColor = [UIColor colorGloomyColor];
    self.statusLabel.backgroundColor = [UIColor colorWithRGBString:@"#ffd701" alpha:1];
}

- (void)setModel:(ODBazaarRequestHelpTasksModel *)model
{
    [self.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.nameLabel.text = model.user_nick;
    //设置Label显示不同大小的字体
    NSString *time = [[[model.task_start_date substringFromIndex:5] stringByReplacingOccurrencesOfString:@"/" withString:@"."] stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:time];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 5)];
    self.timeLabel.attributedText = noteStr;
    self.statusLabel.text = @"任务开始";
    
    // 计算正文实际Size
    CGSize concentSize = [model.content od_sizeWithFontSize:11.0f
                                                    maxSize:CGSizeMake(KScreenWidth - 83, 30)];
    self.contentLabelConstraint.constant = concentSize.height;
}


@end
