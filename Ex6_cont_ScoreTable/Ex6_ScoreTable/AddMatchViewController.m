//
//  AddMatchViewController.m
//  Ex6_ScoreTable
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "AddMatchViewController.h"
#import "DBHelper.h"

@interface AddMatchViewController (){
    
    IBOutlet UIPickerView *teamNamePicker;
    IBOutlet UITextField *teamAScore;
    IBOutlet UITextField *teamBScore;
    
    NSArray *listTeamsName;
    int teamAIndex,teamBIndex;
}

@end

@implementation AddMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //load file team
    NSString *file = [[NSBundle mainBundle] pathForResource:@"footballTeams" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:file];
    listTeamsName = data[@"team_name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////// touch hidden keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [teamAScore resignFirstResponder];
    [teamBScore resignFirstResponder];
}

/////// Action Submit score
- (IBAction)submitScore {
    if (teamAIndex!=teamBIndex) {
        //save score ...
        
        BOOL addOk = [[DBHelper sharedInstance] addNewMatchTeamA:listTeamsName[teamAIndex]
                                                          scoreA:[teamAScore.text intValue]
                                                           teamB:listTeamsName[teamBIndex]
                                                          scoreB:[teamBScore.text intValue]];
       
        
        //alert success ...
        NSString *text = [NSString stringWithFormat:@"%@ %@ - %@ %@",listTeamsName[teamAIndex],teamAScore.text,teamBScore.text,listTeamsName[teamBIndex]];
        NSString *title = @"-Save Completed-^^";
        if (!addOk) {
            text = @"FAIL!!!";
            title = @"---!";
        }
        
        [[[UIAlertView alloc] initWithTitle:title
                                    message:text
                                   delegate:addOk?self:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil] show];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"---!"
                                   message:@"Duplicate Team Name"
                                  delegate:nil
                         cancelButtonTitle:@"Close"
                          otherButtonTitles:nil] show];
    }
    
}




///////////////// UIPicker View Datasource /////////////////
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return listTeamsName.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *teamName = [[listTeamsName[row] uppercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return teamName;
}

///// Custom View
/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (view==nil) {
        view = [[UILabel alloc] init];
    }
    
    NSString *teamName = [[listTeamsName[row] uppercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    [(UILabel*)view setText:teamName];
    [view sizeToFit];
    
    return view;
}*/

//////////////// UIPicker View Delegate ////////////////////
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        teamAIndex = row;
    }else{
        teamBIndex = row;
    }
    
}


//////////////// Text Field Delegate ///////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length<2 && ([string intValue]>0 || [string isEqualToString:@"0"])) {
        textField.text = @"";
        return YES;
    }
    
    return NO;
}

///////////////// Dialog Delagate ///////////////////////////
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //back to score table
    [self.navigationController popViewControllerAnimated:YES];
}



@end
