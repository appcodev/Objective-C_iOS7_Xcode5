//
//  ViewController.m
//  Ex9_SimpleApi_1
//
//  Created by Chalermchon Samana on 6/26/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//  4:30 AM

#import "ViewController.h"

#define SIMPLE_API_1    @"http://localhost/simple-api/1.0/file/hello"
#define XML             @".xml"
#define JSON            @".json"

@interface ViewController () <NSURLConnectionDataDelegate,UITableViewDataSource,NSXMLParserDelegate>{
    NSMutableData *responeData;
    NSString *currentType;
    NSMutableArray *hosts;
    
    IBOutlet UITextView *rawOutput;
    IBOutlet UIImageView *image;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subTitleLabel;
    IBOutlet UILabel *infoLabel;
    IBOutlet UITableView *hostTable;
    
    //xml
    NSString *currentXMLTag;
    NSMutableDictionary *currentHost;
    BOOL inHostTag;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self connect:XML];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//action
- (IBAction)xmlRequest:(id)sender {
    [self connect:XML];
}
- (IBAction)refresh:(id)sender {
    [self connect:currentType];
}
- (IBAction)jsonRequest:(id)sender {
    [self connect:JSON];
}



//connect
- (void)connect:(NSString*)type{
    
    if (![type isEqualToString:XML]&&![type isEqualToString:JSON]) {
        return;
    }
    
    currentType = type;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SIMPLE_API_1,type];
    
    //url
    NSURL *url = [NSURL URLWithString:urlString];
    
    //request
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //connection
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    
    if (connection) {
        responeData = [NSMutableData new];
        hosts = [NSMutableArray new];
    }
    
}

/// error alert
- (void)alertError:(NSError*)error{
    [[[UIAlertView alloc] initWithTitle:@"---!"
                               message:error.description
                              delegate:nil
                     cancelButtonTitle:@"Close"
                      otherButtonTitles:nil] show];
    
}

/// set data
- (void)setUIForDictionary:(NSDictionary*)dic{
    //NSLog(@"%@",dic);
    //title
    titleLabel.text = dic[@"name"];
    //text
    subTitleLabel.text = dic[@"text"];
    //image
    NSURL *url = [NSURL URLWithString:dic[@"image"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    image.image = [UIImage imageWithData:imageData];
    //info : id, date
    NSDictionary *info = dic[@"info"];
    NSString *infoText = [NSString stringWithFormat:@"ID:%@ (%@)",info[@"id"],info[@"date"]];
    infoLabel.text = infoText;
    
    //table ...
    hosts = dic[@"hosts"];
    [hostTable reloadData];
}

/// table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *data = hosts[indexPath.row];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",data[@"country"],data[@"year"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"World Cup Host";
}

/// connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responeData setLength:0];//initial
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responeData appendData:data];//++
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self alertError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *rawData = [[NSString alloc] initWithData:responeData encoding:NSUTF8StringEncoding];
    rawOutput.text = rawData;
    
    if ([currentType isEqualToString:XML]) {
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responeData];
        parser.delegate = self;
        [parser parse];
        
    }else if([currentType isEqualToString:JSON]){
        NSError *jsonError = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responeData
                                                            options:0
                                                              error:&jsonError];
        
        [self setUIForDictionary:dic];
    }
    
}

/// Parser delegate (XML formatter)
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    //table reload
    [hostTable reloadData];
}

//element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentXMLTag = elementName;
    
    //info: id,date
    if ([currentXMLTag isEqualToString:@"info"] && attributeDict!=nil) {
        NSString *infoText = [NSString stringWithFormat:@"ID:%@ (%@)",attributeDict[@"id"],attributeDict[@"date"]];
        infoLabel.text = infoText;
    }else if([currentXMLTag isEqualToString:@"host"]){
        currentHost = [NSMutableDictionary new];
        inHostTag = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"host"]) {
        //NSLog(@"host %@",currentHost);
        [hosts addObject:currentHost];
        inHostTag = NO;
    }

}

//found
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    
    if ([currentXMLTag isEqualToString:@"name"]) {
        //title
        titleLabel.text = string;
    }else if([currentXMLTag isEqualToString:@"text"]){
        //text
        subTitleLabel.text = string;
    }else if([currentXMLTag isEqualToString:@"image"]){
        //image
        NSURL *url = [NSURL URLWithString:string];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image.image = [UIImage imageWithData:imageData];
    }
    
    //host
    if (inHostTag) {
        if ([currentXMLTag isEqualToString:@"country"]) {
            currentHost[@"country"] = string;
        }else if([currentXMLTag isEqualToString:@"year"]){
            currentHost[@"year"] = string;
        }
    }
    
}



@end
