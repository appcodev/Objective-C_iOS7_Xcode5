//
//  Match.h
//  Ex6_Cont_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic,strong) NSString *teamA,*teamB;
@property (nonatomic,readwrite) int teamAScore,teamBScore;

@end
