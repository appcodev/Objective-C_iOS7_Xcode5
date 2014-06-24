//
//  FifaItem.h
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FifaItem : NSObject

@property (nonatomic,strong) NSString *title,*link,*desc,*imageURL;
@property (nonatomic,strong) NSString *pubDate;
@property (nonatomic,strong) NSMutableDictionary *category;

@end
