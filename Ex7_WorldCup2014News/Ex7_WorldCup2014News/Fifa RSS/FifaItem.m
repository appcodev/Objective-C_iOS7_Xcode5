//
//  FifaItem.m
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "FifaItem.h"

@implementation FifaItem

- (id)init{
    self = [super init];
    
    if (self) {
        _category = [NSMutableDictionary new];
    }
    
    return self;
}

/*
 @property (nonatomic,strong) NSString *title,*link,*desc,*imageURL;
 @property (nonatomic,strong) NSDate *pubDate;
 @property (nonatomic,strong) NSMutableDictionary *category;
 */
- (NSString *)description{
    return [NSString stringWithFormat:@"|||ITEM|||\ntitle:%@\nlink:%@\ndesc:%@\nimage url:%@\npub date:%@\ncategory:%@",_title,_link,_desc,_imageURL,_pubDate,_category];
}

@end
