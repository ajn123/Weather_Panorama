//
//  FirstViewController.h
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *zipCodePromptLabel;


@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *pressureMbLabel;


@property (weak, nonatomic) IBOutlet UILabel *tempCLabel;

@property (weak, nonatomic) IBOutlet UIButton *zipCodeGoButton;

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *windChillLabel;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;

- (IBAction)segControlPressed:(id)sender;

- (IBAction)pressedZipCodeGoButton:(id)sender;


@property (readonly)    SystemSoundID   weatherSoundID;
@property (readwrite)   CFURLRef        soundFileURLRef;


@property (readonly)    SystemSoundID   weatherSoundIDThunder;
@property (readwrite)   CFURLRef        soundFileURLRefThunder;


@property (readonly)    SystemSoundID   weatherSoundIDRain;
@property (readwrite)   CFURLRef        soundFileURLRefRain;



@property (readonly)    SystemSoundID   weatherSoundIDSunny;
@property (readwrite)   CFURLRef        soundFileURLRefSunny;



@end