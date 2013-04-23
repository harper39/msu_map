//
//  JSONParser.h
//  msu_map
//
//  Created by Minh Pham on 11/10/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JSONParser : NSObject

// Query database to get an array of lat, long
// \return an array of lat, long
- (NSArray*)getPathToDestination:(NSString*)buildingID
                    :(NSNumber*)latitude
                    :(NSNumber*)longitude;
@end
