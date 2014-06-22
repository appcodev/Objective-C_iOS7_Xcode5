//
//  ViewController.m
//  Ex2_MyFootballTeam
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Page2ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIFont *font = [UIFont fontWithName:@"Brasil 14" size:25];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel*)view setFont:font];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextView:(UIButton *)sender {
    [self performSegueWithIdentifier:@"go" sender:@(sender.tag)];
}

//prepare segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"go"]) {
        [(Page2ViewController*)segue.destinationViewController setTeamNum:[sender intValue]];
    }
}



@end
