//
//  AppDelegate.h
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Global Data countryCities is used by classes in this project
@property (strong, nonatomic) NSMutableDictionary *weatherToDo;

@end