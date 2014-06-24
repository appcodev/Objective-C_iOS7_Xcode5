//
//  NewsWebViewController.m
//  Ex7_WorldCup2014News
//
//  Created by Chalermchon Samana on 6/24/14.
//  Copyright (c) 2014 Onzondev Innovation Co., Ltd. All rights reserved.
//

#import "NewsWebViewController.h"

@interface NewsWebViewController ()<UIWebViewDelegate>{
    
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *loadingIcon;
}


@end

@implementation NewsWebViewController

- (void)viewWillAppear:(BOOL)animated{
    NSURL *url = [NSURL URLWithString:_openURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
    [loadingIcon startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [loadingIcon stopAnimating];
}

@end
