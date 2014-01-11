//
//  WeatherWebViewController.h
//  Weather
//
//  Created by Ajs mac on 11/27/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSMutableArray *data;

@end