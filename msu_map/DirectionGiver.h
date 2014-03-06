//
//  DirectionGiver.h
//  msu_map
//
//  Created by Pham Khac Minh on 2/18/14.
//  Copyright (c) 2014 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SegmentHandler.h"

// Give direction base on current location
// update the direction and segHandler segmentArray if necessary
@interface DirectionGiver : NSObject

@property (strong) NSString* directionString;

typedef NS_ENUM(NSInteger, UpdateState) {
    UpdateStatusBar, // should update the status bar with new direction
    NoAction, // no action necessary
    ChangePath // significant deviation from original path, need to query the server again
};

// init with a seg handler object
-(id) initWithSegHandler: (SegmentHandler*) aSegHandler;

// Decide whether to update direction giver or not
-(UpdateState) updateLocationLatitude: (NSNumber*) latitude longitude: (NSNumber*) longitude;

- (int) getCurrSegInx; // index of segment the current location is on right now
- (int) getCurrPointInx; // index in the current segment of the current location

@end
