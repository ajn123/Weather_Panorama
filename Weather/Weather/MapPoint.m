//
//  MapPoint.m
//  Weather
//
//  Created by Ajs mac on 12/14/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//


#import "MapPoint.h"

@implementation MapPoint

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate  {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

-(NSString *)title {
    return _name;
}

//Gets the subtitle
-(NSString *)subtitle {
    return _address;
}

@end