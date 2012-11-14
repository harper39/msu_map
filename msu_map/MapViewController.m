;//
//  FirstViewController.m
//  msu_map
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    MapView *mapView;
    JSONParser *parse;
    CurrentLocation *currLoc;
}
@synthesize buildingID;

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
    [self drawRoute];
}

// Draw path between current location and building
// Can also be used to update route
// pre buildingID must not be nil
- (void) drawRoute
{
    if (buildingID != nil)
    {
        [mapView ClearOverlays];
        // Retrieve users current location
        [currLoc Start];
        NSNumber* latitude  = @42.729944;
        NSNumber* longitude = @(-84.473534);
        latitude = [currLoc latitude];
        longitude = [currLoc longitude];
        NSLog(@"%@", [currLoc deviceLocation]);
    
        // Retrieve the path array frrom server using JSON parser
        NSArray *path = [parse getPathToDestination:buildingID
                                               :latitude
                                               :longitude];
    
        [mapView addOverlayArray:path];
        
    }
    else {
        NSLog(@"Building ID has not been initialize");
    }
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
