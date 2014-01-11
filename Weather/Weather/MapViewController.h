//
//  MapViewController.h
//  Weather
//
//  Created by Ajs mac on 12/14/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kGOOGLE_API_KEY @"AIzaSyCnIFgxsXIEAhDFI9CDkEjzvKQl_PKgG9Q"
#define kAPIKey dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    int distance;
    BOOL pageHasDisplayed;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D locationCenter;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)firstButtonPressed:(id)sender;
- (IBAction)seconfButtonClicked:(id)sender;
- (IBAction)parkButtonClicked:(id)sender;



@end