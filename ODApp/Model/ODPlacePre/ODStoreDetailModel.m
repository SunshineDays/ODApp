//
//  ODStoreDetailModel.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODStoreDetailModel.h"

@implementation ODStoreDetailDeviceListModel


@end

@implementation ODStoreDetailModel

+ (void)initialize
{
    [ODStoreDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"device_list" :[ODStoreDetailDeviceListModel class],
                };
    }];
}

@end

ODRequestResultIsDictionaryImplementation(ODStoreDetailModel)
