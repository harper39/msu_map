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

- (id) init: (MapViewController*) window;
- (void) UpdateRoute;
- (void) clearAll;

// Add overlay to the map with an array of path
- (void) addOverlayArray: (NSArray*) path;
- (void) clearOverlays;

// Add a point annotation to the map using the point coordinate (lat, long) and a text to display
- (void) addAnnotation: (NSNumber*) latitude
                      : (NSNumber*) longitude
                      : (NSString*) text;
- (void) clearAnnotations;

@end