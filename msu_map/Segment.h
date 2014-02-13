//
//  Segment.h
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represent a segment with points, length, type and name
@interface Segment : NSObject

// init with properly format json object
- (id) initWithJSON: (NSDictionary*) json;

- (NSArray*) getPath; // get an array of lat and long consist of this segment
@end
