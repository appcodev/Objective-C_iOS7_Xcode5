//
//  ViewController.m
//  Ex6_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "DBHelper.h"
#import "Match.h"

@interface ViewController (){
    
    IBOutlet UITableView *scoreTableView;
    NSArray *allMatchsScore;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //table view regis nib cell...
    UINib *uiNib = [UINib nibWithNibName:@"ScoreTableViewCell" bundle:[NSBundle mainBundle]];
    [scoreTableView registerNib:uiNib forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //db load
    allMatchsScore = [[DBHelper sharedInstance] allMatchs];
    
    [scoreTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////// Table View Datasource ////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allMatchsScore.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //data
    Match *matchData = allMatchsScore[indexPath.row];
    
    //team A
    UIImageView *t1Image    = (UIImageView*)[cell viewWithTag:1];
    NSString *t1ImageName   = [NSString stringWithFormat:@"f_%@.png",matchData.teamA];
    t1Image.image           = [UIImage imageNamed:t1ImageName];
    
    UILabel *t1Label        = (UILabel*)[cell viewWithTag:2];
    t1Label.text            = [matchData.teamA.uppercaseString stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
    UILabel *t1ScoreLabel   = (UILabel*)[cell viewWithTag:3];
    t1ScoreLabel.text       = [NSString stringWithFormat:@"%d",matchData.teamAScore];
    
    //team B
    UIImageView *t2Image    = (UIImageView*)[cell viewWithTag:6];
    NSString *t2ImageName   = [NSString stringWithFormat:@"f_%@.png",matchData.teamB];
    t2Image.image           = [UIImage imageNamed:t2ImageName];
    
    UILabel *t2Label        = (UILabel*)[cell viewWithTag:5];
    t2Label.text            = [matchData.teamB.uppercaseString stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
    UILabel *t2ScoreLabel   = (UILabel*)[cell viewWithTag:4];
    t2ScoreLabel.text       = [NSString stringWithFormat:@"%d",matchData.teamBScore];
    
    
    return cell;
}

//////////////////// Table View Delegate //////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
