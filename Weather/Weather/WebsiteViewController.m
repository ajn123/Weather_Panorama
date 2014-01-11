//
//  WebsiteViewController.m
//  Weather
//
//  Created by Ajs mac on 12/13/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import "WebsiteViewController.h"
@interface WebsiteViewController ()


@end


@implementation WebsiteViewController

// When the view loads, the web view object is asked to show the default homepage.
- (void)viewDidLoad {
    
    [super viewDidLoad];   // Inform Super
    
#ifdef DEBUG
    NSLog(@"Website URL received in the Website View Controller = %@", self.websiteURL);
#endif
    
    // Asks the UIWebView object to display the web page at URL = websiteURL
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.websiteURL]]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // Starting to load the web page. Show the animated activity indicator in the status bar
    // to indicate to the user that the UIWebVIew object is busy loading the web page.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Finished loading the web page. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Ignore this error if the page is instantly redirected via javascript or in another way
    if([error code] == NSURLErrorCancelled) return;
    
    // An error occurred during the web page load. Hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Create the error message in HTML as a character string object pointed to by errorString
    NSString *errorString = [NSString stringWithFormat:
                             @"<html><font size=+2 color='red'><p>An error occurred: %@<br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>",
                             error.localizedDescription];
    
    // Display the error message within the UIWebView object
    [self.webView loadHTMLString:errorString baseURL:nil];
}

@end
