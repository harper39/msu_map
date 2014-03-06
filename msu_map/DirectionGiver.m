//
//  DirectionGiver.m
//  msu_map
//
//  Created by Pham Khac Minh on 2/18/14.
//  Copyright (c) 2014 Minh Pham. All rights reserved.
//

#import "DirectionGiver.h"
#import "Segment.h"

@implementation DirectionGiver {
    SegmentHandler* segHandler;
    int currSegInx; // index of segment the current location is on right now
    int currPointInx; // index in the current segment of the current location
}

@synthesize directionString;

-(id) initWithSegHandler:(SegmentHandler *)aSegHandler
{
    segHandler = aSegHandler;
    currSegInx = [[segHandler getAllSegments] count] - 1;
    currPointInx = [[[[segHandler getAllSegments] lastObject] getPath] count] - 1;
    directionString = @"Direction not ready";
    
    return self;
}

// Compute bearing and change it to clock format
- (NSNumber*) convertBearingToClock: (CGFloat) bearingDegrees
{
    // intersection is the same as start or end point
    if (bearingDegrees == NZERO) return NULL;
    
    int clock = (int) (bearingDegrees + 15) / 30;
    clock = 12 - (clock + 6) % 12;
    return [NSNumber numberWithInt:clock];
}

// Decide to update or not
-(UpdateState) updateLocationLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
    int newSegInx = 0;
    int newPointInx = 0;
    
    // looping throught the segment array
    for (int i=[segHandler count]-1; i>=0; i--)
    {
        newPointInx = [[[segHandler getAllSegments] objectAtIndex:i] findIndexOfLat:latitude long:longitude];
        if (newPointInx >= 0)
        {
            // if found the segment with current location
            newSegInx = i;
            break;
        }
    }
    
    if (newPointInx > 0)
    {
        // found something
        currPointInx = newPointInx;
        currSegInx = newSegInx;
    }
    else if (newPointInx < 0)
    {
        directionString = @"abc";
        return ChangePath;
    }
    
    return NoAction;
}

// index of segment the current location is on right now
- (int) getCurrSegInx
{
    return currSegInx;
}

// index in the current segment of the current location
- (int) getCurrPointInx
{
    return currPointInx;
}

@end
