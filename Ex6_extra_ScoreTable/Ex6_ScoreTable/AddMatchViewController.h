//
//  AddMatchViewController.h
//  Ex6_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Match;

@interface AddMatchViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) Match *fixEditMatch;

@end
