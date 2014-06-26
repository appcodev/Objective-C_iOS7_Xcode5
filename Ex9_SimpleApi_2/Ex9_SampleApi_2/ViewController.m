//
//  ViewController.m
//  Ex9_SampleApi_2
//
//  Created by Chalermchon Samana on 6/26/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//  9.30 AM

#import "ViewController.h"

#define API_URL     @"http://localhost/simple-api/1.0/file/footballteam"
#define XML         @".xml"
#define JSON        @".json"

@interface ViewController ()<NSURLConnectionDataDelegate,NSXMLParserDelegate,UITableViewDataSource>{
    NSString *connectType;
    NSMutableData *responseData;
    
    NSMutableArray *groups,*currentTeams;
    NSMutableDictionary *currentGroup,*currentTeam;
    
    NSString *currentXMLTag;
    IBOutlet UITableView *teamsTable;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

- (void)connect:(NSString*)type{
    if (![type isEqualToString:XML] && ![type isEqualToString:JSON]) {
        return;
    }
    connectType = type;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_URL,connectType];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];

    //connection
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (connect) {
        responseData = [NSMutableData new];
    }
    
}

//// action
- (IBAction)refresh:(id)sender {
    [self connect:connectType];
}
- (IBAction)connectAction:(id)sender {
    [self connect:[sender tag]==1?XML:JSON];
}


///////////////////////////// Table View Data Source ////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    
    NSDictionary *team = groups[indexPath.section][@"teams"][indexPath.row];
    
    cell.textLabel.text = team[@"name"];
    cell.detailTextLabel.text = team[@"id"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:team[@"image"]]];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return groups.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return groups[section][@"id"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [groups[section][@"teams"] count];
}



//////////// Echo Error ///////////////////////
- (void)echoError:(NSString*)error{
    [[[UIAlertView alloc] initWithTitle:@"---!"
                                message:error
                               delegate:nil
                      cancelButtonTitle:@"close"
                      otherButtonTitles:nil] show];
}


//////////// Connection Delegate //////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self echoError:error.description];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",data);
    
    if ([connectType isEqualToString:XML]) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
        parser.delegate = self;
        if (![parser parse]) {
            [self echoError:@"Parse event error!"];
        }
    }else if([connectType isEqualToString:JSON]){
        NSError *jError;
        NSDictionary *jDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jError];
        
        groups = jDict[@"groups"];
        
        [teamsTable reloadData];
    }
    
}

////////// Parser Delegate ///////////////////
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [teamsTable reloadData];
}

///element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentXMLTag = elementName;
    
    if ([currentXMLTag isEqualToString:@"groups"]) {
        groups = [NSMutableArray new];
    }else if([currentXMLTag isEqualToString:@"group"] && attributeDict!=nil){
        currentGroup = [NSMutableDictionary new];
        currentGroup[@"id"] = attributeDict[@"id"];//id
        
    }else if([currentXMLTag isEqualToString:@"teams"]){
        currentTeams = [NSMutableArray new];
    }else if([currentXMLTag isEqualToString:@"team"]){
        currentTeam = [NSMutableDictionary new];
        currentTeam[@"id"] = attributeDict[@"id"];//team id
        //NSLog(@"--> %@",currentTeam[@"id"]);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"group"]){
        [groups addObject:currentGroup];
    }else if([elementName isEqualToString:@"team"]){
        [currentTeams addObject:currentTeam];
    }else if([elementName isEqualToString:@"teams"]){
        currentGroup[@"teams"] = currentTeams;
    }
}

//found
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    //NSLog(@"-- %@:%@",currentXMLTag,string);
    
    if ([currentXMLTag isEqualToString:@"name"]) {
        currentTeam[@"name"] = string;
    }else if([currentXMLTag isEqualToString:@"image"]){
        currentTeam[@"image"] = string;
    }
}

@end
