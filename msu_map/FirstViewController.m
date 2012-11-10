;//
//  FirstViewController.m
//  msu_map
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController{
    MapView *mapView;
    JSONParser *parse;
    CurrentLocation *currLoc;
}


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
    
    // Retrieve users current location
    [currLoc Start];
    NSNumber* latitude  = @42.729944;
    NSNumber* longitude = @(-84.473534);
    NSString* buildingID = @"0022";
    
    latitude = [currLoc latitude];
    longitude = [currLoc longitude];
    NSLog(@"%@", [currLoc deviceLocation]);
    
    NSArray *path = [parse getPathToDestination:buildingID
                                  :latitude
                                  :longitude];
    
    [mapView addOverlayArray:path];
    
}

//  Destructor
- (void) dealloc
{
    mapView = nil;
    parse = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
