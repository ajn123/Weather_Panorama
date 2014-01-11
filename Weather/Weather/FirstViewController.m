//
//  FirstViewController.m
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>

NSString *weatherConditions;

NSDictionary *currentObservation;

NSDictionary *estimatedForecast;

NSDictionary *displayLocation;

//Underground API key
const NSString *kWundergroundKey = @"a1953b8d8392bc0b";

@interface FirstViewController () <CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
}
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.weatherIcon.image =[UIImage imageNamed: @"compass"];
    
    NSURL *soundFilePath = [[NSBundle mainBundle] URLForResource: @"wind-02" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.soundFileURLRef = (__bridge CFURLRef) soundFilePath;
 
    AudioServicesCreateSystemSoundID (self.soundFileURLRef, &_weatherSoundID);
    
    soundFilePath = [[NSBundle mainBundle] URLForResource: @"thunder-03" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.soundFileURLRefThunder = (__bridge CFURLRef) soundFilePath;
    
    AudioServicesCreateSystemSoundID (self.soundFileURLRefThunder, &_weatherSoundIDThunder);
    
    soundFilePath = [[NSBundle mainBundle] URLForResource: @"rain-light-01" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.soundFileURLRefRain = (__bridge CFURLRef) soundFilePath;
    
    AudioServicesCreateSystemSoundID (self.soundFileURLRefRain, &_weatherSoundIDRain);

    
    soundFilePath = [[NSBundle mainBundle] URLForResource: @"Sunny" withExtension: @"wav"];
    
    // Casting Objective-C pointer type "NSURL *" to C pointer type CFURLRef requires a bridged cast.
    self.soundFileURLRefSunny = (__bridge CFURLRef) soundFilePath;
    
    AudioServicesCreateSystemSoundID (self.soundFileURLRefSunny, &_weatherSoundIDSunny);

    [self startSignificantUpdates];
 
    UIBarButtonItem *socialButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  target:self action:@selector(socialMedia:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = socialButton;

}


//Dismisses the keyboard  
-(void)dismissKeyboard {
    [self.zipCodeTextField resignFirstResponder];
}


- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}

//Alows the user to share the weather socially.
- (void)socialMedia:(id)sender
{
 
    UIActivityViewController *objVC  =[[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:@"This Weather Panorama App by Alex Norton is Sweet!"] applicationActivities:nil];
    
    [self presentViewController:objVC animated:YES completion:nil];
    
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}



- (void)viewDidUnload
{
    if (self.weatherSoundID) {
        AudioServicesDisposeSystemSoundID(_weatherSoundID);
    }
    
    [super viewDidUnload];
}
//Deallocate the sounds
- (void)dealloc
{
    if (self.weatherSoundID) {
        AudioServicesDisposeSystemSoundID(_weatherSoundID);
    }
    if (self.weatherSoundIDRain) {
        AudioServicesDisposeSystemSoundID(_weatherSoundIDRain);
    }
    if (self.weatherSoundIDSunny) {
        AudioServicesDisposeSystemSoundID(_weatherSoundIDSunny);
    }
    if (self.weatherSoundIDThunder) {
        AudioServicesDisposeSystemSoundID(_weatherSoundIDThunder);
    }
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

//Plays sound based on weather.
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // If the detected motion is a shaking motion
    if (motion == UIEventSubtypeMotionShake) {
        
        if ([weatherConditions isEqualToString:@"Clear"] )
        {
            AudioServicesPlaySystemSound (_weatherSoundIDSunny);
        }
        else if ([weatherConditions isEqualToString:@"Mostly Cloudy"] || [weatherConditions isEqualToString:@"Overcasts"])
        {
            AudioServicesPlaySystemSound (_weatherSoundIDThunder);
        }
        else if ([weatherConditions isEqualToString:@"Rain"] )
        {
            AudioServicesPlaySystemSound (_weatherSoundIDRain);
        }
        else
        {
            AudioServicesPlaySystemSound (_weatherSoundIDSunny);
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Stops all services
- (void)updateStatusMessage:(NSString *)userInterfaceMessage
      stopActivityIndicator:(BOOL)stopActivityIndicator
       stopLocationServices:(BOOL)stopLocationServices
                 logMessage:(id)systemLogInformation
{
    
    if (stopLocationServices)
        [self stopSignificantUpdates];
    
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

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    
    [self retrieveWeatherForLocation:location orZipCode:nil];
}





#pragma mark - Methods for retrieving weather from Wunderground

- (void)retrieveWeatherForLocation:(CLLocation *)location orZipCode:(NSString *)zipCode
{
    NSString *urlString;
    
    // get URL for current conditions
    
    if (location)
    {
        // based upon longitude and latitude returned by CLLocationManager
        
        urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%+f,%+f.json",
                     kWundergroundKey,
                     location.coordinate.latitude,
                     location.coordinate.longitude];
    }
    else if ([zipCode length] == 5)
    {
        // based upon the zip code
        
        urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json",
                     kWundergroundKey,
                     zipCode];
        
    }
    
    [self updateStatusMessage:@"Identified location; determining weather" stopActivityIndicator:NO stopLocationServices:NO logMessage:urlString];
    
    NSURL *url          = [NSURL URLWithString:urlString];
    
    NSData *weatherData = [NSData dataWithContentsOfURL:url];
    
    // make sure we were able to get some response from the URL; if not
    if (weatherData == nil)
    {
        [self updateStatusMessage:@"Unable to retrieve data from weather service" stopActivityIndicator:YES stopLocationServices:YES logMessage:@"weatherData is nil"];
        return;
    }
    
    // parse the JSON results
    NSError *error;
    id weatherResults = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:&error];
    

    //Check JSON response for correctness
    NSDictionary *response = weatherResults[@"response"];
    if (response == nil || ![response isKindOfClass:[NSDictionary class]])
    {
        [self updateStatusMessage:@"Unable to parse results from weather service" stopActivityIndicator:YES stopLocationServices:YES logMessage:weatherResults];
        return;
    }
    
    
    //Get the API JSON data
    currentObservation = weatherResults[@"current_observation"];
    
    estimatedForecast=  currentObservation[@"estimated"];
    
    
    displayLocation=  currentObservation[@"display_location"];
    
    
    self.zipCodePromptLabel.text = displayLocation[@"full"];
    
    NSString *statusMessage;
    
    statusMessage = @"Retrieved barometric pressure";
    
    weatherConditions = currentObservation[@"weather"];
    
    self.statusLabel.text = [[NSString alloc] initWithFormat:@"Current forecast:  %@",currentObservation[@"weather"]];
    
    [self forecastTemperatureChanged];
    
    // update the user interface status message
    
    [self updateStatusMessage:statusMessage stopActivityIndicator:YES stopLocationServices:YES logMessage:weatherResults];
}


// only allow numeric characters
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = NO;
    NSString *newValue = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL goButtonHidden = (self.zipCodeGoButton.alpha < 0.5);
    BOOL goButtonShouldHide;
    
  
    NSCharacterSet *nonNumeric = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (([string rangeOfCharacterFromSet:nonNumeric].location == NSNotFound) && [newValue length] <= 5)
    {
        shouldChange = YES;
        
        // and while we're here, show the go button if the length is exactly five characters
        
        goButtonShouldHide = ([newValue length] != 5);
        
        if (goButtonHidden != goButtonShouldHide)
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.zipCodeGoButton.alpha = goButtonShouldHide ? 0.0 : 1.0;
                             }];
            
            textField.returnKeyType = (goButtonShouldHide ? UIReturnKeyDone : UIReturnKeyGo);
        }
    }
    
    return shouldChange;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //Zip codes are only lenght of 5
    if ([textField.text length] == 5)
    {
        [self retrieveWeatherForLocation:nil orZipCode:textField.text];
    }
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)segControlPressed:(id)sender {
    
    [self forecastTemperatureChanged];
    
}


/**
 Updates the temperature control based on the segment control selected index, 0 for farenheight,
 1 for celcius.
 */
-(void) forecastTemperatureChanged{
    
    if (self.segControl.selectedSegmentIndex == 0) {
        NSNumber *tempC = currentObservation[@"temp_f"];
        
        NSString *newLabelText = [[NSString alloc] initWithFormat:@"Current Temperature: %@°F", tempC];
        
        self.tempCLabel.text = newLabelText;
        
        
        
        self.pressureMbLabel.text = [[NSString alloc] initWithFormat:@"Feels Like: %@°F",currentObservation[@"feelslike_f"]];
        
        
    self.windChillLabel.text = [[NSString alloc] initWithFormat:@"Wind Chill: %@°F",currentObservation[@"windchill_f"]];
        
    }
    else
    {
        NSNumber *tempC = currentObservation[@"temp_c"];
        
        NSString *newLabelText = [[NSString alloc] initWithFormat:@"Current Temperature: %@°C", tempC];
        
        self.tempCLabel.text = newLabelText;
        
        self.pressureMbLabel.text = [[NSString alloc] initWithFormat:@"Feels Like:  %@°C",currentObservation[@"feelslike_c"]];
        
        self.windChillLabel.text = [[NSString alloc] initWithFormat:@"Wind Chill: %@°C",currentObservation[@"windchill_c"]];
        
    }
    [self calculateWeatherImage];
}


//Calculate the correct image to display based on the weather.
- (void) calculateWeatherImage{
    
    if ([weatherConditions isEqualToString:@"Clear"] )
    {
         self.weatherIcon.image =[UIImage imageNamed: @"sunny1"];
    }
    else if ([weatherConditions isEqualToString:@"Mostly Cloudy"] )
    {
        self.weatherIcon.image =[UIImage imageNamed: @"cloudy"];
        
    }
    else if ([weatherConditions isEqualToString:@"Partly Cloudy"] )
    {
        
        self.weatherIcon.image =[UIImage imageNamed: @"cloudy"];
        
    }
    else if ([weatherConditions isEqualToString:@"Scattered Clouds"] )
    {
        
        self.weatherIcon.image =[UIImage imageNamed: @"cloudy"];
        
    }
    else if ([weatherConditions isEqualToString:@"Rain"] )
    {
        
        self.weatherIcon.image =[UIImage imageNamed: @"rain"];
    }
    else if ([weatherConditions isEqualToString:@"Overcast"] )
    {
        
        self.weatherIcon.image =[UIImage imageNamed: @"cloudy"];
    }
    else if ([weatherConditions isEqualToString:@"Fog"] )
    {
        
        self.weatherIcon.image =[UIImage imageNamed: @"fog"];
    }
    else
    {
        self.weatherIcon.image =[UIImage imageNamed: @"compass"];
    }
}


- (IBAction)pressedZipCodeGoButton:(id)sender
{
    [self.zipCodeTextField resignFirstResponder];
    
    if ([self.zipCodeTextField.text length] == 5)
    {
        [self retrieveWeatherForLocation:nil orZipCode:self.zipCodeTextField.text];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"Please enter five number zip code"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

// detect touches anywhere on the screen, and if so, dismiss the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.zipCodeTextField resignFirstResponder];
}
@end