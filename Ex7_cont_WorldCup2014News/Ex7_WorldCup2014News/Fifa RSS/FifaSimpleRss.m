//
//  FifaSimpleRss.m
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "FifaSimpleRss.h"



//fix rss v. 2.0 : 1 channel
@interface FifaSimpleRss(){
    NSString *currentElement;
    //state
    BOOL inImageTag,inItemTag;
    //date formatter
    //NSDateFormatter *dateFormatter;
}

@end

@implementation FifaSimpleRss

- (id)init{
    self = [super init];
    
    if (self) {
        _imageData = [NSMutableDictionary new];
        _listItems = [NSMutableArray new];
        
        //flag
        inImageTag      = NO;
        inItemTag       = NO;
        
        //date formatter
        //dateFormatter = [[NSDateFormatter alloc] init];
        //Tue, 24 Jun 2014 08:23:00 GMT
        
        //[dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
        //[dateFormatter setDateFormat:@"EEE, d MM yyyy HH:mm:ss zzz"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    
    return self;
}

/*
 @property (nonatomic,strong) NSString *title,*link,*desc,*language,*copyright,*category;
 @property (nonatomic,strong) NSDate *pubDate,*lastBuildDate;
 @property (nonatomic,strong) NSMutableDictionary *imageData;
 @property (nonatomic,strong) NSMutableArray *listItems;
 */
- (NSString *)description{
    
    NSMutableString *allItemText = [NSMutableString new];
    for (FifaItem *item in _listItems) {
        [allItemText appendString:@"\n"];
        [allItemText appendString:item.description];
    }
    
    return [NSString stringWithFormat:@"Title:%@\nlink:%@\ndesc:%@\nlanguage:%@\ncopyright:%@\ncategory:%@\npub date:%@\nlast build date:%@\nimage data:%@\nlist item:%@",_title,_link,_desc,_language,_copyright,_category,_pubDate,_lastBuildDate,_imageData,allItemText];
}
 

- (void)readElement:(NSString*)element attributes:(NSDictionary*)attributeDic{
    currentElement  = element;
    
    if ([currentElement isEqualToString:@"image"]) {
        inImageTag = YES;
    }else if([currentElement isEqualToString:@"item"]){
        inItemTag = YES;
        
        //new item...
        FifaItem *item = [[FifaItem alloc] init];
        [_listItems addObject:item];
    }else if(inItemTag && [currentElement isEqualToString:@"enclosure"] && attributeDic != nil){
        FifaItem *lastItem = [_listItems lastObject];
        
        lastItem.imageURL = attributeDic[@"url"];
    }
}

- (void)endElement:(NSString*)element{
    if ([element isEqualToString:@"image"]) {
        inImageTag = NO;
    }else if([element isEqualToString:@"item"]){
        inItemTag = NO;
    }
}

- (void)foundText:(NSString*)text{
    //make sure text..
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text isEqualToString:@""]) {
        return;
    }
    
    if (inImageTag) {
        _imageData[currentElement] = text;//set new key & value
    }else if(inItemTag){
        FifaItem *lastItem = [_listItems lastObject];
        
        if ([currentElement isEqualToString:@"link"]) {
            lastItem.link = text;
        }else if([currentElement isEqualToString:@"pubDate"]){
            lastItem.pubDate = text;
        }else if([currentElement isEqualToString:@"category"]){
            NSArray *cates = [text componentsSeparatedByString:@"="];
            if (cates.count==2) {
                lastItem.category[cates[0]] = cates[1];
            }
        }
    }else{
        if([currentElement isEqualToString:@"link"]){
            _link = text;
        }else if([currentElement isEqualToString:@"language"]){
            _language = text;
        }else if([currentElement isEqualToString:@"copyright"]){
            _copyright = text;
        }else if([currentElement isEqualToString:@"pubDate"]){
            
            _pubDate = text;
        }else if([currentElement isEqualToString:@"lastBuildDate"]){
            _lastBuildDate = text;
        }else if([currentElement isEqualToString:@"category"]){
            _category = text;
        }
    }
}

- (void)foundCDATA:(NSString*)cdata{
    //make sure text..
    cdata = [cdata stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([cdata isEqualToString:@""]) {
        return;
    }
    
    if(inItemTag){
        FifaItem *lastItem = [_listItems lastObject];
        
        if ([currentElement isEqualToString:@"title"]) {
            lastItem.title = cdata;
        }else if([currentElement isEqualToString:@"description"]){
            lastItem.desc = cdata;
        }
    }else{
        if ([currentElement isEqualToString:@"title"]) {
            _title = cdata;
        }else if([currentElement isEqualToString:@"description"]){
            _desc = cdata;
        }
    }
    
}



@end
