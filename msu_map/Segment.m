//
//  Segment.m
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import "Segment.h"

@implementation Segment {

}
@synthesize pointsArray;
@synthesize length;
@synthesize type;
@synthesize name;

// init with all properties
- (id) initWithPath: (NSArray*) aPath
             length: (NSNumber*) aLength
               name: (NSString*) aName
               type: (NSString*) aType
{
    pointsArray = aPath;
    length = aLength;
    name = aName;
    type = aType;
    return self;
}

-(id) initWithJSON: (NSDictionary*) json
{
    length = [json objectForKey:@"LENGTH"];
    type = [json objectForKey:@"TYPE"];
    pointsArray = [json objectForKey:@"POINTS"];
    name = [json objectForKey:@"NAME"];
    
    return self;
}

@end
