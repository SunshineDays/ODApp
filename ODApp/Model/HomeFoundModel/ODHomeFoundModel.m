//
//  ODHomeFoundModel.m
//  ODApp
//
//  Created by Bracelet on 16/1/5.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODHomeFoundModel.h"

@implementation ODHomeFoundModel

-(instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        self.banner_url = dict[@"banner_url"];
        self.img_url = dict[@"img_url"];
        self.title = dict[@"title"];
    }
    
    return self;
}

@end
