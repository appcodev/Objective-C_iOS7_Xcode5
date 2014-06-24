//
//  DBHelper.m
//  Ex6_Cont_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "DBHelper.h"
#import "Match.h"

@implementation DBHelper

+ (DBHelper*)sharedInstance{
    
    static DBHelper* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    
    return instance;
    
}


- (id)init{
    self = [super init];
    
    if (self) {
        //open file && create file
        _dbPath = [self copyDatabaseByFileName:db_file_name];
        
    }
    
    return self;
    
}

//////////////////////////// File Manager ////////////////////////
//call this function to get/copy&get db path file
- (NSString*) copyDatabaseByFileName:(NSString*)dbFile{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbFile];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    //NSLog(@"-%d- %@",success,writableDBPath);
    
    //The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFile];
    if(!success){
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    return writableDBPath;
}

///////////////////////////////////////////////////////////////////

///////////////////////// Example /////////////////////////////////
/*
 //1. open database file
 if(sqlite3_open([_dbPath UTF8String], &db) == SQLITE_OK){
     
     //2. create sql statement
     NSString *sql = @"SELECT * FROM <table_name>";
     sqlite3_stmt *stmt;
     if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
     
        //3. query result
        //สำหรับ select
        //while (sqlite3_step(stmt)==SQLITE_ROW){ }
 
        //สำหรับ insert update delete
        if (sqlite3_step(stmt)==SQLITE_DONE){ }
 
        //close stmt
        sqlite3_finalize(stmt);
     
     }else{
        //sql invalid
     }
     
     //close db...
     sqlite3_close(db);
     
 }else{
     //can't open db
 }

*/
///////////////////////////////////////////////////////////////////
- (NSString*)recheckString:(NSString*)text{
    NSRange range = [text rangeOfString:@"'"];
    if (range.location!=NSNotFound) {
        NSMutableString *mText = [text mutableCopy];
        [mText insertString:@"'" atIndex:range.location];
        return mText;
    }
    
    
    return text;
}

//insert
- (BOOL)addNewMatchTeamA:(NSString*)teamA scoreA:(int)scoreA teamB:(NSString*)teamB scoreB:(int)scoreB{
    sqlite3 *db;
    
    if (sqlite3_open([_dbPath UTF8String], &db) == SQLITE_OK) {
        
        teamA = [self recheckString:teamA];
        teamB = [self recheckString:teamB];
        
        NSString *sql = [NSString stringWithFormat:@"insert into tb_match (teamA_name,teamB_name,teamA_score,teamB_score) values ('%@','%@',%d,%d)",teamA,teamB,scoreA,scoreB];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(stmt)==SQLITE_DONE) {
                return YES;
            }
            
        }else{
            NSLog(@"DB FAIL! : SQL Stement");
        }
        
    }else{
        NSLog(@"DB FAIL! : Open Database file");
    }
    
    return NO;
}

// select
- (NSArray*)allMatchs{
    NSMutableArray *rsArray = [NSMutableArray new];
    sqlite3 *db;
    
    if (sqlite3_open([_dbPath UTF8String], &db) == SQLITE_OK) {
        
        NSString *sql = @"select * from tb_match order by id desc";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                Match *m = [[Match alloc] init];
                
                const char *teamA = (const char*)sqlite3_column_text(stmt, 1);
                int teamAScore = sqlite3_column_int(stmt, 2);
                const char *teamB = (const char*)sqlite3_column_text(stmt, 3);
                int teamBScore = sqlite3_column_int(stmt, 4);
                
                m.teamA = [NSString stringWithUTF8String:teamA];
                m.teamAScore = teamAScore;
                m.teamB = [NSString stringWithUTF8String:teamB];
                m.teamBScore = teamBScore;
                
                [rsArray addObject:m];
            }
            
            
            
        }else{
            NSLog(@"DB FAIL! : SQL Stement");
        }
        
    }else{
        NSLog(@"DB FAIL! : Open Database file");
    }
    
    return rsArray;
    
    
}

@end
