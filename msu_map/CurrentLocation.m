//
//  CurrentLocation.m
//  msu_map
//
//  Created by Minh Pham on 11/9/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "CurrentLocation.h"

// Current location class
@implementation CurrentLocation {
	CLLocationManager *locationManager;
}


/*
// Constructor
- (id) init
{
    if(!(self = [super init]))
        return nil;
    locationManager = [[CLLocationManager alloc] init];
    
    return self;
}
*/
 
// Destructor
- (void) dealloc
{
    [locationManager stopUpdatingLocation];
}

// Update the location
- (void) Start{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

// Stop the location service
- (void) Stop{
    [locationManager stopUpdatingLocation];
}


// Get current latitude
- (NSNumber* ) latitude{    
    return [NSNumber numberWithDouble:locationManager.location.coordinate.
     latitude];
     
    //return [NSNumber numberWithDouble:42.729944];
}

// Get current longitude
- (NSNumber* ) longitude{
    return [NSNumber numberWithDouble:locationManager.location.coordinate.
     longitude];
    
    //return [NSNumber numberWithDouble:-84.473534];
}

// Get current location in nice format
- (NSString *) deviceLocation {

    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
    return theLocation;
}


#pragma mark - CLLocationManagerDelegate

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {

    }
}

// Fail meessage
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
