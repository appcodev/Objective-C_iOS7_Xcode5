//
//  DBHelper.h
//  Ex6_Cont_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define db_file_name    @"score_table_db.sqlite"

@interface DBHelper : NSObject

@property (nonatomic,strong) NSString *dbPath;

+ (DBHelper*)sharedInstance;

//add
- (BOOL)addNewMatchTeamA:(NSString*)teamA scoreA:(int)scoreA teamB:(NSString*)teamB scoreB:(int)scoreB;
//select
- (NSArray*)allMatchs;

@end
