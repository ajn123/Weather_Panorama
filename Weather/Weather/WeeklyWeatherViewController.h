//
//  WeeklyWeatherViewController.h
//  Weather
//
//  Created by Ajs mac on 12/15/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyWeatherViewController : UIViewController  <UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *summaryBox;
@property (weak, nonatomic) IBOutlet UITableView *tableOfWeeklyUpdates;

@end
