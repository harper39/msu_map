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

@end
