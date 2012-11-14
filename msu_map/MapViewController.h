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

// Control map view
@interface MapViewController : UIViewController
@property (strong) NSString *buildingID;

// draw a route on the map using building id
// the building ID can be set by setBuildingID
- (void) drawRoute;
@end
