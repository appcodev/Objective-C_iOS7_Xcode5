//
//  ViewController.m
//  Ex8_WorldCupTweet
//
//  Created by Chalermchon Samana on 6/25/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

#define max_tweet_query     @"40"
#define max_annotation      50

@interface ViewController ()<UITableViewDataSource>{
    NSArray *allTweets;
    IBOutlet MKMapView *map;

    IBOutlet UITableView *tweetTable;
    IBOutlet UIActivityIndicatorView *loadingIcon;
    UIRefreshControl *refreshControl;
    
    NSTimer *timer;
    BOOL inLoadingTweets;
}

@property (nonatomic,strong) ACAccountStore *accountStore;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
	// Do any additional setup after loading the view, typically from a nib.
    allTweets = [[NSArray alloc] init];
    
    //regis nib for table
    UINib *nibCell = [UINib nibWithNibName:@"TweetTableViewCell" bundle:[NSBundle mainBundle]];
    [tweetTable registerNib:nibCell forCellReuseIdentifier:@"cell"];
    
    //Refresh Controller
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadQuery) forControlEvents:UIControlEventValueChanged];
    [tweetTable addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated{
    [self autoRefresh];
    
    [self loadQuery];
    [self reloadMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTweetsData{
    [tweetTable reloadData];
    [tweetTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self reloadMap];
    
    [refreshControl endRefreshing];
    [loadingIcon stopAnimating];
    inLoadingTweets = NO;
}

- (void)reloadMap{
    
    //init zoom wole world
    /*
     http://sugartin.info/2013/11/25/mkmapview-zoom-out-to-view-the-whole-world/
     http://stackoverflow.com/questions/4749374/mkmapview-reset-back-to-world-view
     */
    // step.1 create co-ordianate-span as follows
    MKCoordinateSpan span = MKCoordinateSpanMake(180, 360);
    // step.2 crate region as follows
    MKCoordinateRegion region = MKCoordinateRegionMake(map.centerCoordinate, span);
    // step.3 zoom using region to map as follows
    [map setRegion:region animated:YES];
    
    //load anotation
    if(allTweets!=nil && allTweets.count>0){
        
        for (NSDictionary *dic in allTweets) {
            NSDictionary *geo = dic[@"geo"];
            if (![geo isKindOfClass:[NSNull class]]) {
                NSArray *coordinates = geo[@"coordinates"];
                
                CLLocationDegrees lat = [coordinates[0] floatValue];
                CLLocationDegrees lng = [coordinates[1] floatValue];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                
                MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
                anno.coordinate = location.coordinate;
                
                NSDictionary *user = dic[@"user"];
                NSString *title = [NSString stringWithFormat:@"@%@",user[@"screen_name"]];
                NSString *subTitle = [NSString stringWithFormat:@"tweets %@ | followers %@",user[@"statuses_count"],user[@"followers_count"]];
                
                anno.title = title;
                anno.subtitle = subTitle;
                
                [map addAnnotation:anno];
                
                if (map.annotations.count>max_annotation) {
                    [map removeAnnotation:[map.annotations firstObject]];
                }
            }
        }
        
        //move for newest
        id<MKAnnotation> anno = [map.annotations lastObject];
        CLLocationCoordinate2D target = [anno coordinate];
        MKCoordinateRegion region2 = MKCoordinateRegionMake(target, span);
        [map setRegion:region2 animated:YES];
        
        
    }
    
}


//self.account
- (ACAccountStore *)accountStore{
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    return _accountStore;
}

//load query
- (void)loadQuery{
    
    if (!inLoadingTweets) {
        inLoadingTweets = YES;
    }else{
        NSLog(@"x Ignore query...");
        return;
    }
    
    NSLog(@">>> Query...");
    [loadingIcon startAnimating];
    //[refreshControl beginRefreshing];
    
    NSString *worldcupQuery = [@"#worldcup2014" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:nil completion:^(BOOL granted, NSError *error) {
                                                   
                                                   if (granted) {
                                                       NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                                                       NSDictionary *parameters = @{@"count":max_tweet_query ,@"q":worldcupQuery};
                                                       
                                                       SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                                                 requestMethod:SLRequestMethodGET
                                                                                                           URL:url
                                                                                                    parameters:parameters];
                                                       
                                                       NSArray *account = [self.accountStore accountsWithAccountType:accountType];
                                                       slRequest.account = [account lastObject];
                                                       
                                                       [slRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                           
                                                           if (error==nil) {
                                                               //NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                               //NSLog(@"data %@",data);
                                                               
                                                               //json parse
                                                               NSError *jsonError;
                                                               NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                                                               if (!jsonError) {
                                                                   if (jsonData!=nil) {
                                                                       allTweets = jsonData[@"statuses"];
                                                                       
                                                                       //table reload...
                                                                       //[self reloadTweetsData];
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           //table reload...
                                                                           [self reloadTweetsData];
                                                                       });
                                                                   }
                                                               }else{
                                                                   [loadingIcon stopAnimating];
                                                                   [refreshControl endRefreshing];
                                                                   NSLog(@"JSon Error : %@",jsonError);
                                                                   inLoadingTweets = NO;
                                                               }
                                                               
                                                               
                                                           }else{
                                                               [loadingIcon stopAnimating];
                                                               [refreshControl endRefreshing];
                                                               inLoadingTweets = NO;
                                                               NSLog(@"Error : %@",error);
                                                           }
                                                           
                                                       }];
                                                       
                                                   }else{
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           //table reload...
                                                           [self reloadTweetsData];
                                                       });
                                                   }
                                                   
                                                   
                                               }];
}

///////////// Table View Data Source /////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *tweet = allTweets[indexPath.row];
    
    //tweet
    UILabel *label1 = (UILabel*)[cell viewWithTag:2];
    label1.text = tweet[@"text"];
    
    //user
    NSDictionary *user = tweet[@"user"];
    UILabel *label2 = (UILabel*)[cell viewWithTag:3];
    label2.text = [NSString stringWithFormat:@"@%@",user[@"screen_name"]];
    
    //image
    __weak UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.layer.cornerRadius = imageView.bounds.size.width/2;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:user[@"profile_image_url"]]];
    [imageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"placeholder"]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  //set image
                                  imageView.image = image;
                                  
                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  NSLog(@"Load Image Error : %@",error);
                              }];
    
    return cell;
}

///////////// Timer   /////////////
- (void)autoRefresh{
    NSLog(@"start autoRefresh...");
    timer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                             target:self
                                           selector:@selector(autoRefreshLoop:)
                                           userInfo:nil
                                            repeats:YES];
    
    
}

- (void)autoRefreshLoop:(NSTimer*)timer{
    [self loadQuery];
}


///////////// action  ////////////
- (IBAction)refresh:(id)sender {
    [self loadQuery];
}


- (IBAction)share:(UIBarButtonItem *)sender {
    
    SLComposeViewController *slView = [SLComposeViewController composeViewControllerForServiceType:sender.tag==1?SLServiceTypeFacebook:SLServiceTypeTwitter];
    
    [slView setInitialText:[NSString stringWithFormat:@"World Cup 2014 Tweets #WorldCup2014"]];
    
    //capture screen
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *captureScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [slView addImage:captureScreen];
    
    [self presentViewController:slView animated:YES completion:nil];
}


@end
