//
//  CContentViewController.m
//  CUnion
//
//  Created by Andrey Kuritsin on 26.11.12.
//  Copyright (c) 2012 Andrey Kuritsin. All rights reserved.
//

#import "CContentViewController.h"
#import "NSString+Stripping.h"

@interface CContentViewController ()

@end

@implementation CContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([_delegate respondsToSelector:@selector(contentViewControllerDidHide:)])
    {
        [_delegate contentViewControllerDidHide:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutInterface];
}

- (void)layoutInterface
{
    CGSize size = self.view.bounds.size;
    
    _webView.frame = CGRectMake(0.0f, 44.0f, size.width, size.height - 44.0f);
}

- (void)refresh
{
    [_webView stopLoading];
    
    if (!_item)
    {
        [self.webView loadHTMLString:@"" baseURL:nil];
        
        return;
    }
    
    _host = @"http://postkomsg.com/";
    
	_titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg.png"]];
    self.titleTextLabel.text = [_item objectForKey:@"@title"];
    
    NSString *content = [_item objectForKey:@"content"];
    
    if (!content)
    {
        [self.webView loadHTMLString:@"" baseURL:nil];
    }
    else
    {
        [self.webView loadHTMLString:content baseURL:[NSURL URLWithString:_host]];
    }
    FTLog(@"%@",content)
}

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self layoutInterface];
}

#pragma mark - UIWebViewDelegate <NSObject>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *absURLStr = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([absURLStr rangeOfString:@"about:blank"].location != NSNotFound || [absURLStr isEqualToString:_host])
    {
        return YES;
    }
    else if([absURLStr rangeOfString:@"http"].location != NSNotFound)
    {
        FTLog(@"%@", absURLStr);
        
        NSURL *url = [NSURL URLWithString:absURLStr];
        
        if (url)
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
    return NO;
}

@end
