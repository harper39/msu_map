;//
//  FirstViewController.m
//  msu_map
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "MapViewController.h"
#include "Building.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    MapView *mapView;
    JSONParser *parse;
    CurrentLocation *currLoc;
}
@synthesize destinationBuilding;

// Constructor
- (void) viewDidLoad
{
    mapView = [[MapView alloc] init:self];
    parse = [JSONParser alloc];
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
        NSNumber* latitude  = @42.729944;
        NSNumber* longitude = @(-84.473534);
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
        }
        else
        {
            NSLog(@"Cannot connect to server");
        }
    }
    else {
        NSLog(@"destinationBuilding has not been initialize");
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
