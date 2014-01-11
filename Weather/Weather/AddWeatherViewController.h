//
//  AddWeatherViewController.h
//  Weather
//
//  Created by Ajs mac on 11/27/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddWeatherViewControllerDelegate;


@interface AddWeatherViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *weatherName;
@property (strong, nonatomic) IBOutlet UITextField *toDoName;
@property (nonatomic, assign) id <AddWeatherViewControllerDelegate> delegate;

// The keyboardDone: method is invoked when the user taps Done on the keyboard
- (IBAction)keyboardDone:(id)sender;

// The save: method is invoked when the user taps the Save button created at run time.
- (void)save:(id)sender;

@end



@protocol AddWeatherViewControllerDelegate

- (void)addWeatherViewController:(AddWeatherViewController *)controller didFinishWithSave:(BOOL)save;

@end
