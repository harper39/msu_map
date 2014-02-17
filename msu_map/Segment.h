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
@property (strong) NSArray* pointsArray;
@property (strong) NSNumber* length;
@property (strong) NSString* name;
@property (strong) NSString* type;

// init with properly format json object
- (id) initWithJSON: (NSDictionary*) json;

// init with all properties
- (id) initWithPath: (NSArray*) aPath
             length: (NSNumber*) aLength
               name: (NSString*) aName
               type: (NSString*) aType;

@end
