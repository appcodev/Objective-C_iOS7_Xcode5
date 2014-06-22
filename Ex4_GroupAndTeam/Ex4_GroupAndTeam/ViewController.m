//
//  ViewController.m
//  Ex4_GroupAndTeam
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Page2ViewController.h"

@interface ViewController (){
    NSArray *groupIndex;
    NSDictionary *groupTeam;
    
    UIFont *font;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //group team
    groupIndex = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
    
    groupTeam = @{@"A":@[@"brazil",@"croatia",@"mexico",@"cameroon"],
                  @"B":@[@"spain",@"netherlands",@"chile",@"australia"],
                  @"C":@[@"colombia",@"greece",@"côte_d'lvoire",@"japan"],
                  @"D":@[@"uruguay",@"costa_rica",@"england",@"italy"],
                  @"E":@[@"switzerland",@"ecuador",@"france",@"honduras"],
                  @"F":@[@"argentina",@"bosnia-herzegovina",@"iran",@"nigeria"],
                  @"G":@[@"germany",@"portugal",@"ghana",@"usa"],
                  @"H":@[@"belgium",@"algeria",@"russia",@"korea_republic"]};
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    font = [UIFont fontWithName:@"brasil 14" size:16];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///// Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return groupTeam.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)groupTeam[groupIndex[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Group %@",groupIndex[section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell!=nil) {
        NSString *groupName = groupIndex[indexPath.section];
        NSArray *group = groupTeam[groupName];
        NSString *teamName = group[indexPath.row];
        
        //team flag
        UIImageView *flagImage = (UIImageView*)[cell viewWithTag:1];
        NSString *imageName = [NSString stringWithFormat:@"f_%@.png",teamName];
        flagImage.image = [UIImage imageNamed:imageName];
        
        //team name
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:2];
        
        nameLabel.font = font;
        nameLabel.text = [teamName.capitalizedString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
    }
    
    return cell;
    
}


///// Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"go" sender:indexPath];
}

//prepare segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"go"]) {
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        NSString *groupName = groupIndex[indexPath.section];
        NSString *teamName = groupTeam[groupName][indexPath.row];
        
        [(Page2ViewController*)segue.destinationViewController setTeamName:teamName];
    }
}

@end
