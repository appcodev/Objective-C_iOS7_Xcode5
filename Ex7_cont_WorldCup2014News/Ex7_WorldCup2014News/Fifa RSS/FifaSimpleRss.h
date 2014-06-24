//
//  FifaSimpleRss.h
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FifaItem.h"

@interface FifaSimpleRss : NSObject

@property (nonatomic,strong) NSString *title,*link,*desc,*language,*copyright,*category;
@property (nonatomic,strong) NSString *pubDate,*lastBuildDate;
@property (nonatomic,strong) NSMutableDictionary *imageData;
@property (nonatomic,strong) NSMutableArray *listItems;

- (void)readElement:(NSString*)element attributes:(NSDictionary*)attributeDic;
- (void)endElement:(NSString*)element;

- (void)foundText:(NSString*)text;
- (void)foundCDATA:(NSString*)cdata;

@end
