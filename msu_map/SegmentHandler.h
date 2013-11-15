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

// Return the bearing in degree to turn through the intersection
- (CGFloat) getBearingFrom: (CGPoint) startPoint
                   intersect: (CGPoint) intersection
                          to: (CGPoint) endPoint;

@end
