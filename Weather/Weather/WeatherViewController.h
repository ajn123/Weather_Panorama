//
//  WeatherViewController.h
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AddWeatherViewController.h"
#import "AppDelegate.h"

@class AppDelegate;


@interface WeatherViewController : UITableViewController <AddWeatherViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *weatherTableView;

@end