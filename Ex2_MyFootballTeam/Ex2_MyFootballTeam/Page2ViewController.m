//
//  Page2ViewController.m
//  Ex2_MyFootballTeam
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "Page2ViewController.h"

@interface Page2ViewController (){
    
    IBOutlet UIImageView *shirtImage;
    IBOutlet UIImageView *flagImage;
    IBOutlet UINavigationItem *navTitle;
}

@end

@implementation Page2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = nil;
    
    switch (_teamNum) {
        case 1:{
            title = @"Brazil";
            break;
        }
        case 2:{
            title = @"France";
            break;
        }
        case 3:{
            title = @"Germany";
            break;
        }
        case 4:{
            title = @"Spain";
            break;
        }
    }
    
    navTitle.title = title;
    
    NSString *shirtName = [NSString stringWithFormat:@"s_%@.png",title.lowercaseString];
    shirtImage.image = [UIImage imageNamed:shirtName];
    
    NSString *flagName = [NSString stringWithFormat:@"b_%@.png",title.lowercaseString];
    flagImage.image = [UIImage imageNamed:flagName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
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
