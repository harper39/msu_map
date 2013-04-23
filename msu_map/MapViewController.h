//
//  FirstViewController.h
//  msu_map
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#include "MapView.h"
#include "JSONParser.h"
#include "GoogleMaps.h"

// Forward reference
@class Building;

// Control map view
@interface MapViewController : UIViewController
@property (strong) Building *destinationBuilding;

// draw a route on the map using destinationBuilding
// can be used to update route
- (void) drawRoute;

// draw route to a building
- (void) drawRouteFromCurrentLocationToBuilding: (Building*) building;
@end
