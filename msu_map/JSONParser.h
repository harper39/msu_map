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

- (NSArray*)getPathToDestination:(NSString*)buildingID
                    :(NSNumber*)latitude
                    :(NSNumber*)longitude;
@end
