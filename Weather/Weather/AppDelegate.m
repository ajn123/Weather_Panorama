//
//  AppDelegate.m
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//


#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /************************************
     All application-specific and user data files must be written to the Documents directory. Nothing can be written
     into application's main bundle because it is locked for writing after your app is published. The contents of the
     Documents directory are backed up by iTunes during backup of an iOS device. Therefore, the user can recover the
     data written by your app from an earlier device backup.
     
     The Documents directory path on an iOS device is different from the one used for iOS Simulator.
     
     To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
     However, this function was designed originally for Mac OS X, where multiple such directories could exist.
     Therefore, it returns an array of paths rather than a single path.
     For iOS, the resulting array's objectAtIndex:0 is the path to the Documents directory.
     ************************************/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"WeatherToDo.plist"];
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file
    NSMutableDictionary *weatherData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!weatherData) {
     
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"WeatherToDo" ofType:@"plist"];
        
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        weatherData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    
    self.weatherToDo = weatherData;
    
    
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (locationNotification) {
        
        [application cancelAllLocalNotifications];
    }
    
    //Google maps API key
    [GMSServices provideAPIKey:@"AIzaSyDejMBTPl7jLgPMkEc1cE562thsCm3iqB8"];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"WeatherToDo.plist"];
    
    [self.weatherToDo writeToFile:plistFilePathInDocumentsDirectory atomically:YES];

}


@end

