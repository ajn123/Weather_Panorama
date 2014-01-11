//
//  WhatToWearViewController.h
//  Weather
//
//  Created by Ajs mac on 12/13/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WhatToWearViewController : UITableViewController


@property (strong, nonatomic) NSDictionary *WeatherLinksDict;
@property (strong, nonatomic) NSDictionary *WeatherLogosDict;
@property (strong, nonatomic) NSDictionary *URLDicts;

@property (strong, nonatomic) NSArray *weatherConditionsArray;
@property (strong, nonatomic) NSArray *categoryNames;
@property (strong, nonatomic) NSArray *toDoElements;



@property (strong, nonatomic) NSDictionary *weatherToElemenetsDict;

@end