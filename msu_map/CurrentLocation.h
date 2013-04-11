//
//  CurrentLocation.h
//  msu_map
//
//  Created by Minh Pham on 11/9/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class MapView;

@interface CurrentLocation : NSObject<CLLocationManagerDelegate>

- (void) Start;
- (void) Stop;

- (NSString *) deviceLocation;
- (NSNumber *) latitude;
- (NSNumber *) longitude;
- (CLLocationCoordinate2D) location;

@end
