//
//  MapViewController.m
//  Weather
//
//  Created by Ajs mac on 12/14/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapPoint.h"

@interface MapViewController() <CLLocationManagerDelegate>

@end


@implementation MapViewController
 


- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,5000,5000);
    [mv setRegion:region animated:YES];
}



-(void) queryGooglePlaces: (NSString *) googleType {
   //Google Places API String to get information
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", locationCenter.latitude, locationCenter.longitude, [NSString stringWithFormat:@"%i", distance], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kAPIKey, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    [self plotPositions:places];
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //calculate zoom.
    MKMapRect rectangle = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(rectangle), MKMapRectGetMidY(rectangle));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(rectangle), MKMapRectGetMidY(rectangle));
    
    //Set the current distance
    distance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint) + 50;
    //Set your current center point
    locationCenter = self.mapView.centerCoordinate;
}




-(void)plotPositions:(NSArray *)data {
    //  Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    // Gets the correction annotation information for Google Place API and displays it.
    for (int i=0; i<[data count]; i++) {
        NSDictionary* place = [data objectAtIndex:i];
        NSDictionary *geometry = [place objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        NSString *name = [place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        CLLocationCoordinate2D placeCoord;
        placeCoord.latitude=[[location objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[location objectForKey:@"lng"] doubleValue];
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.mapView addAnnotation:placeObject];
    }
}


//Views the annotation selected
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MapPoint";
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}


//Looks for restuarants in Google Place API
- (IBAction)firstButtonPressed:(id)sender {
     [self queryGooglePlaces:@"restaurant"];
  
}

//Looks for gyms in Google Place API
- (IBAction)seconfButtonClicked:(id)sender {
      [self queryGooglePlaces:@"gym"];
}


//Looks for parks in Google Place API
- (IBAction)parkButtonClicked:(id)sender {
    
    [self queryGooglePlaces:@"park"];
}




@end