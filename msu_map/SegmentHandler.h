//
//  SegmentHandler.h
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Segment.h"
#import "DirectionGiver.h"

// Manage all segments
@interface SegmentHandler : NSObject

@property (strong) NSNumber* pathLength; // the total length of the path
@property (strong) DirectionGiver* dirGiver; // a direction giver object

// Constructor with content of the json query
- (id) initWithContent: (NSDictionary*) content;

// get current path from segments and current location
- (NSArray*) getCurrentPath;

// Return an array of all segments
- (NSArray*) getAllSegments;

// Return the number of segments
- (NSUInteger*) count;

// Get the length of the path till current location
// length is in feet
- (double) getCurrentPathLength;

// Reduce the number of segments by
// merging straight segments of same type together
- (void) trimSegment;

// Compute the bearing to switch from one segment to another
// \param fromSegInx the index of the 'from' segment
// \param toSegInx the index of the 'to segment
- (CGFloat) getBearingFromSegmentIndex: (int) fromSegInx to: (int)toSegInx;

@end
