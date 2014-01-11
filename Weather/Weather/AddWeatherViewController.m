//
//  AddWeatherViewController.m
//  Weather
//
//  Created by Ajs mac on 11/27/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import "AddWeatherViewController.h"

@interface AddWeatherViewController ()

@end

@implementation AddWeatherViewController

- (void)viewDidLoad
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    
   self.navigationItem.rightBarButtonItem = saveButton;
}


- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}


//Dismisses the keyboard
-(void)dismissKeyboard {
    [self.weatherName resignFirstResponder];
    [self.toDoName resignFirstResponder];
}



- (void)save:(id)sender
{
    
    if(self.weatherName.text.length == 0 || self.toDoName.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please fill out info"
                                                        message:@"Please fill out all the text boxes"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self.delegate addWeatherViewController:self didFinishWithSave:YES];
    }
}

@end
