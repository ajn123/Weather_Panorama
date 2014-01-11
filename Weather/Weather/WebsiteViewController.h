//
//  WebsiteViewController.h
//  Weather
//
//  Created by Ajs mac on 12/13/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebsiteViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *websiteURL;

@end
