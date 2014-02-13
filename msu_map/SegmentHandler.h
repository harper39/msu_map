//
//  SegmentHandler.h
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

// Manage all segments
@interface SegmentHandler : NSObject

- (id) initWithGeometry: (NSArray*) geometry;

- (NSArray*) getPath; // get path from segments

// Return an array of all segments
- (NSArray*) getAllSegments;

// Return the bearing in degree to turn through the intersection
- (CGFloat) getBearingFrom: (CGPoint) startPoint
                   intersect: (CGPoint) intersection
                          to: (CGPoint) endPoint;

// Return the bearing in "clock format" to turn thourgh intersection
// Return 1, 2, 3, ..., 12
// 12 o'clock is straight ahead
- (NSNumber*) getClockBearing: (CGPoint) from
                    intersect: (CGPoint) mid
                           to: (CGPoint) to;
@end
