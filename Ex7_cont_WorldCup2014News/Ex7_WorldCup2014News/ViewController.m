//
//  ViewController.m
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "NewsWebViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FifaSimpleRss.h"

#define rss_feed_url    @"http://www.fifa.com/worldcup/news/rss.xml"

@interface ViewController ()<NSURLConnectionDataDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableData *feedData;
    FifaSimpleRss *simpleRss;
    
    
    IBOutlet UIActivityIndicatorView *loadingIcon;
    IBOutlet UITableView *newsTable;

    UIRefreshControl *refreshControl;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //table regis
    UINib *nib = [UINib nibWithNibName:@"NewsCellViewTableViewCell" bundle:[NSBundle mainBundle]];
    [newsTable registerNib:nib forCellReuseIdentifier:@"cell"];
    
    //refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    [newsTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(connect) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [self connect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////////// network connect
- (void)connect{
    [loadingIcon startAnimating];
    
    NSURL *url = [NSURL URLWithString:rss_feed_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        feedData = [NSMutableData new];
        
        [refreshControl endRefreshing];
    }
}

/////////// connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [feedData setLength:0];
    [loadingIcon startAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [feedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connect Error: %@",error);
    
    [[[UIAlertView alloc] initWithTitle:@"---!"
                               message:[error description]
                              delegate:nil
                     cancelButtonTitle:@"Close"
                      otherButtonTitles:nil] show];
    [loadingIcon stopAnimating];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSString *feedXML = [[NSString alloc] initWithData:feedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",feedXML);
    
    //Parser
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:feedData];
    xmlParser.delegate = self;
    [xmlParser parse];
}

/////////// parser delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //new fifa simple rss
    simpleRss = [[FifaSimpleRss alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"--> %@",simpleRss);
    [newsTable reloadData];
    
    [loadingIcon stopAnimating];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    //NSLog(@"Parser Error: %@",parseError);
}

///
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //NSLog(@"Element <%@ (%@)",elementName,attributeDict);
    [simpleRss readElement:elementName attributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"Elememt %@>",elementName);
    [simpleRss endElement:elementName];
}

//found something...
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    //NSLog(@"CDATA %@",[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]);
    NSString *cdata = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [simpleRss foundCDATA:cdata];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"> %@",string);
    [simpleRss foundText:string];
}

///////////////////////////// Table View Data source ////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%d",simpleRss.listItems.count);
    return simpleRss.listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    FifaItem *item = simpleRss.listItems[indexPath.row];
    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.text = item.title;
    
    UILabel *date = (UILabel*)[cell viewWithTag:2];
    date.text = item.pubDate;
    
    __weak UIImageView *imageView = (UIImageView*)[cell viewWithTag:3];
//    //Way 1 ... load image data directly ...
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:item.imageURL]];
//    imageView.image = [[UIImage alloc] initWithData:imageData];
    
    //Way 2 ... load in background thread ...
//    NSDictionary *data = @{@"imageView":imageView,
//                           @"url":item.imageURL};
//    [self performSelectorInBackground:@selector(loadImage:) withObject:data];
    
    //Way 3 ... Use https://github.com/AFNetworking/AFNetworking ...
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:item.imageURL]];
    [imageView setImageWithURLRequest:urlReq
                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              imageView.image = image;
                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              NSLog(@"Fail!");
                          }];
    
    
    return cell;
    
}

//- (void)loadImage:(NSDictionary*)data{
//    @autoreleasepool {
//        UIImageView *imageView = data[@"imageView"];
//        NSString *urlText = data[@"url"];
//        
//        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlText]];
//        imageView.image = [[UIImage alloc] initWithData:imageData];
//    }
//    
//}


/////////////////////////// Table View Delegate ///////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FifaItem *item = simpleRss.listItems[indexPath.row];
    [self performSegueWithIdentifier:@"read" sender:item.link];
}


///prepare segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"read"]) {
        [(NewsWebViewController*)segue.destinationViewController setOpenURL:sender];
    }
}


@end
