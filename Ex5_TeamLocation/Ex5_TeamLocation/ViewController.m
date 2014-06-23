//
//  ViewController.m
//  Ex5_TeamLocation
//
//  Created by Chalermchon Samana on 6/23/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "Page2ViewController.h"

@interface ViewController (){
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //show user location
    _mapView.showsUserLocation = YES;
    
    //setup map
    [self setupAllLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAllLocations{
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"teamLocation" ofType:@"plist"];
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:file];
    
    [dataDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *loc = [(NSString*)obj componentsSeparatedByString:@", "];
        if (loc.count==2) {
            CLLocationDegrees lat = [loc[0] floatValue];
            CLLocationDegrees lng = [loc[1] floatValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            
            MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
            anno.coordinate = location.coordinate;
            anno.title = [[(NSString*)key uppercaseString] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            anno.subtitle = key;
            
            [_mapView addAnnotation:anno];
        }
        
    }];
}

//map delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *PINId = @"wcPin";
    //NSLog(@"%@",[annotation title]);
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:PINId];
    
    if (!pin) {
        pin = (MKPinAnnotationView*)[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PINId];
    }
    
    NSString *imgName = [NSString stringWithFormat:@"f_%@.png",[annotation subtitle]];
    NSString *imgBallName = [NSString stringWithFormat:@"b_%@.png",[annotation subtitle]];
    //NSLog(@"img %@",imgName);
    
    UIImage *ball = [UIImage imageNamed:imgBallName];
    UIImage *miniBall = [UIImage imageWithCGImage:ball.CGImage
                                            scale:4.5
                                      orientation:ball.imageOrientation];
    pin.image = miniBall;;
    
    UIImage *flag = [UIImage imageNamed:imgName];
    UIImage *miniFlag = [UIImage imageWithCGImage:flag.CGImage scale:2 orientation:flag.imageOrientation];
    pin.leftCalloutAccessoryView = [[UIImageView alloc]initWithImage:miniFlag];
    pin.canShowCallout = YES;
    
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //NSLog(@"control %@",control);
    //go
    [self performSegueWithIdentifier:@"go" sender:[view.annotation subtitle]];
    
}

//prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"go"]) {
        [(Page2ViewController*)segue.destinationViewController setTeamName:sender];
    }
}

//action
- (IBAction)changeType:(id)sender {
    if (_mapView.mapType==MKMapTypeStandard) {
        _mapView.mapType=MKMapTypeHybrid;
    }else if(_mapView.mapType==MKMapTypeHybrid){
        _mapView.mapType=MKMapTypeStandard;
    }
}


@end
