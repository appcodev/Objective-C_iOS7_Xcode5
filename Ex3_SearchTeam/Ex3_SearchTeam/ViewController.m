//
//  ViewController.m
//  Ex3_SearchTeam
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    IBOutlet UITextField *textInput;
    IBOutlet UIImageView *shirtImage;
    IBOutlet UILabel *teamNameLabel;
    
    
    NSArray *allTeamName;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    allTeamName = @[@"algeria",@"argentina",@"australia",@"belgium",
                    @"bosnia-herzegovina",@"brazil",@"cameroon",@"chile",
                    @"colombia",@"costa_rica",@"côte_d'lvoire",@"croatia",
                    @"ecuador",@"england",@"france",@"germany",
                    @"ghana",@"greece",@"honduras",@"iran",
                    @"italy",@"japan",@"korea_republic",@"mexico",
                    @"netherlands",@"nigeria",@"portugal",@"russia",
                    @"spain",@"switzerland",@"uruguay",@"usa",];
    
    
    //set font
    UIFont *font = [UIFont fontWithName:@"brasil 14" size:25];
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            [(UILabel*)v setFont:font];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//function for search string
- (NSString*)searchForString:(NSString*)text{
    
    for (NSString *s in allTeamName) {
        NSRange range = [s.lowercaseString rangeOfString:text.lowercaseString];
        if (range.location!=NSNotFound) {
            return s;
        }
    }
    
    return nil;
}

- (IBAction)search {
    NSString *text = textInput.text;
    if (![text isEqualToString:@""]) {
        NSString *rsText = [self searchForString:text];
        
        if (rsText!=nil) {
            NSString *shirtName = [NSString stringWithFormat:@"s_%@.png",rsText];
            shirtImage.image = [UIImage imageNamed:shirtName];
            
            teamNameLabel.text = [rsText.capitalizedString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"...!"
                                        message:@"Not a team!!!"
                                       delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil] show];
        }
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"...!"
                                   message:@"Plz fill team name!!!"
                                  delegate:nil
                         cancelButtonTitle:@"Close"
                          otherButtonTitles:nil] show];
    }
    
    //hide keyboard
    [textInput resignFirstResponder];
    
    //clear text
    textInput.text = @"";
    
}

//touch to hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hide keyboard
    [textInput resignFirstResponder];
}

@end
