//
//  WeeklyWeatherViewController.m
//  Weather
//
//  Created by Ajs mac on 12/15/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import "WeeklyWeatherViewController.h"
#import <CoreLocation/CoreLocation.h>



NSMutableArray *statuses;

const NSString *kForecastKey = @"ce9b4fd6b29e701481ca1619c794b080";

@interface WeeklyWeatherViewController () <CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *locationOfUser;
    UIActivityIndicatorView *activityIndicator;
    id markedWeather;
    
}

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownRecognizer;


- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer;
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer;
@end

@implementation WeeklyWeatherViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleSwipeLeft:)];
    self.swipeLeftRecognizer = leftRecognizer;
    self.swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // Add Swipe Left Gesture Recognizer to the View
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleSwipeRight:)];
    self.swipeRightRecognizer = rightRecognizer;
    self.swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // Add Swipe Right Gesture Recognizer to the View
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipeUp:)];
    self.swipeUpRecognizer = upRecognizer;
    self.swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    // Add Swipe Up Gesture Recognizer to the View
    [self.view addGestureRecognizer:self.swipeUpRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleSwipeDown:)];
    self.swipeDownRecognizer = downRecognizer;
    self.swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    // Add Swipe Down Gesture Recognizer to the View
    [self.view addGestureRecognizer:self.swipeDownRecognizer];
    self.title = @"Weekly Weather";
    statuses = [[NSMutableArray alloc] init];
    [self startSignificantUpdates];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)retrieveWeatherForLocation:(CLLocation *)location
{
    NSString *urlString;
    
        // Gets the JSON based upon longitude and latitude returned by CLLocationManager
    urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%+f,%+f",
                     kForecastKey,
                     location.coordinate.latitude,
                     location.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *weatherData = [NSData dataWithContentsOfURL:url];

    if (weatherData == nil)
    {
        return;
    }

    NSError *error;
    
    //Get the JSOn results from the API.
    id weatherResults = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    markedWeather = weatherResults;
    NSLog(@"%@",weatherResults[@"daily"][@"summary"]);

    self.summaryBox.text= [NSString stringWithFormat:@"Summary of the Week:%@",
    weatherResults[@"daily"][@"summary"]];
    
    
    //Retrieve weekly information.
    for (int i =0 ; i < 7; i++) {
        [statuses addObject:weatherResults[@"daily"][@"data"][i]];
        NSLog(@"%@",  [statuses objectAtIndex:i] );
    }
    
    [self.tableOfWeeklyUpdates reloadData];
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    locationOfUser = [locations lastObject];
    [self retrieveWeatherForLocation:locationOfUser];
}


- (void)startSignificantUpdates
{
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)stopSignificantUpdates
{
    if (locationManager != nil)
    {
        [locationManager stopMonitoringSignificantLocationChanges];
        locationManager = nil;
    }
}




// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if(cell == nil)
    {
        //Make a cell dith detail style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TableViewCell"];
    }
    
     NSUInteger rowNumber = [indexPath row];
    
    id markedWeatherElement = [statuses objectAtIndex:rowNumber];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = markedWeatherElement[@"summary"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"High:%@°F Low:%@°F Chance of Rain: %@",
                                 markedWeatherElement[@"temperatureMax"],markedWeatherElement[@"temperatureMin"],
                                 markedWeatherElement[@"precipProbability"]];
 
 
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [statuses count];
}





/**
Based on the swiping motion below I change the summary text box with new information.
*/
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    
    
    self.summaryBox.text= [NSString stringWithFormat:@"Nearest Store: %@miles",
                           markedWeather[@"currently"][@"nearestStormDistance"]];
    
    [UIView commitAnimations];
}



- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    self.summaryBox.text= [NSString stringWithFormat:@"Humidity: %.1f%%",
                           [markedWeather[@"currently"][@"humidity"]doubleValue ] * 100];
    [UIView commitAnimations];
}


- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer {
    self.summaryBox.text= [NSString stringWithFormat:@"Time zone: %@",
                           markedWeather[@"timezone"]];
    [UIView commitAnimations];
}


- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer {
    self.summaryBox.text= [NSString stringWithFormat:@"Location: Latitude:%.2f Longitude:%.2f",
                           locationOfUser.coordinate.latitude,locationOfUser.coordinate.longitude];
   [UIView commitAnimations];
}



@end
