;//
//  FirstViewController.m
//  msu_map
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "MapViewController.h"
#include "Building.h"

// Distant consider as big enough to separate two point (use to
// compare end point of path with current location)
const double DistanceThreshold = 0.0005;

@interface MapViewController ()

@end

@implementation MapViewController{
    MapView *mapView;
    JSONParser *parse;
    CurrentLocation *currLoc;
    GoogleMaps *googleMaps;
}
@synthesize destinationBuilding;

// Constructor
- (void) viewDidLoad
{
    mapView = [[MapView alloc] init:self];
    parse = [JSONParser alloc];
    googleMaps = [GoogleMaps alloc];
    currLoc = [[CurrentLocation alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //buildingID = @"0022";
}

// Draw path between current location and building
// Can also be used to update route
// pre destinationBuilding must not be nil
- (void) drawRoute
{
    if (destinationBuilding != nil)
    {
        [mapView clearAll];
        
        NSString* buildingID = [destinationBuilding ID];
        
        // Retrieve users current location
        [currLoc Start];
        NSNumber* latitude  = @42.729944; // used for testing
        NSNumber* longitude = @(-84.473534); // used for testing
        latitude = [currLoc latitude];
        longitude = [currLoc longitude];
        NSLog(@"Current location: %@", [currLoc deviceLocation]);
        NSLog(@"Destination location: latitude: %@, longitude: %@", [destinationBuilding latitude], [destinationBuilding longitude]);
        
        // Retrieve the path array frrom server using JSON parser
        NSArray *path = [parse getPathToDestination:buildingID
                                               :latitude
                                               :longitude];
    
        if (path)
        {
            [mapView addOverlayArray:path];
            [mapView addAnnotation: [destinationBuilding latitude] : [destinationBuilding longitude] : [destinationBuilding commonName]];
            
            // Check the path end point (relate to the current location
            CLLocationCoordinate2D endPath = CLLocationCoordinate2DMake([[path objectAtIndex:1] doubleValue], [[path objectAtIndex:0] doubleValue]);
    
            // Calculate the distance between the endpoint and current location
            double dx = (endPath.latitude - [latitude doubleValue]);
            double dy = (endPath.longitude - [longitude doubleValue]);
            double dist = sqrt(dx*dx + dy*dy);
            
            if (dist >= DistanceThreshold)
            {
                // if the distance is bigger than the threshold
                NSLog(@"End point: lat: %f, long: %f", endPath.latitude, endPath.longitude);
                [self getPathFromCurrentLocationToEndPathUsingGoogleMap:endPath];
            }
        }
        else
        {
            NSLog(@"Query from %@,%@ to %@ unsuccessful", latitude, longitude, buildingID);
            NSLog(@"Cannot connect to retrieve path from server");
        }
    }
    else {
        NSLog(@"destinationBuilding has not been initialize");
    }
}

// Draw direction from current location to end path using Apple map kit
-(void) getPathFromCurrentLocationToEndPathUsingGoogleMap: (CLLocationCoordinate2D) endPath
{
    NSArray* path = [googleMaps getRoutesFrom:endPath to:[currLoc location]];
    if (path)
    {
        [mapView addOverlayArray:path];
    }
}


// Draw route from current location to building
-(void) drawRouteFromCurrentLocationToBuilding:(Building *)building
{
    destinationBuilding = building;
    [self drawRoute];
}


//  Destructor
- (void) dealloc
{
    [currLoc Stop];
    mapView = nil;
    parse = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [currLoc Stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
