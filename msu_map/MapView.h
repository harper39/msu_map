//
//  MapView.h
//  msu_map
//
//  Created by Minh Pham on 11/10/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#include "CurrentLocation.h"

@class MapViewController;

@interface MapView : NSObject <MKMapViewDelegate, CLLocationManagerDelegate>

// initialize the mapview given the parent window
- (id) init: (MapViewController*) window;

// Update the route
- (void) UpdateRoute;

// clear all annotation and routes
- (void) clearAll;

// Add overlay to the map with an array of path
// \param path an array of latitude and longitude
- (void) addOverlayArray: (NSArray*) path;
- (void) clearOverlays; // clear all routes

// Add a point annotation to the map using the point coordinate (lat, long) and a text to display
- (void) addAnnotation: (NSNumber*) latitude
                      : (NSNumber*) longitude
                      : (NSString*) text;
- (void) clearAnnotations; // clear all annotations

@end