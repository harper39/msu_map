//
//  SegmentHandler.h
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Segment.h"

// Manage all segments
@interface SegmentHandler : NSObject

// Constructor with content of the json query
- (id) initWithContent: (NSDictionary*) content;

- (NSArray*) getPath; // get path from segments

// Return an array of all segments
- (NSArray*) getAllSegments;

// Return the number of segments
- (NSUInteger*) count;

// Get the length of the entire path
// length is in feet
- (NSNumber*) getPathLength;

// Reduce the number of segments by
// Merging too small segments
// or straight segments of same type together
- (void) trimSegment;


// Return the bearing in degree to turn through the intersection
- (CGFloat) getBearingFrom: (CGPoint) startPoint
                   intersect: (CGPoint) intersection
                          to: (CGPoint) endPoint;

// Compute the bearing to switch from one segment to another
// \param fromSegInx the index of the 'from' segment
// \param toSegInx the index of the 'to segment
- (CGFloat) getBearingFromSegmentIndex: (int) fromSegInx to: (int)toSegInx;

// Return the bearing in "clock format" to turn thourgh intersection
// Return 1, 2, 3, ..., 12
// 12 o'clock is straight ahead
- (NSNumber*) getClockBearing: (CGPoint) from
                    intersect: (CGPoint) mid
                           to: (CGPoint) to;
@end
