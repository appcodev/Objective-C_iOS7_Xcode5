//
//  Page2ViewController.m
//  Ex4_GroupAndTeam
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "Page2ViewController.h"

@interface Page2ViewController (){
    
    IBOutlet UIImageView *shirtImage;
    
}

@end

@implementation Page2ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //image
    NSString *shirtName = [NSString stringWithFormat:@"s_%@.png",_teamName];
    shirtImage.image = [UIImage imageNamed:shirtName];
    
    //title
    self.navigationItem.title = [_teamName.capitalizedString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
