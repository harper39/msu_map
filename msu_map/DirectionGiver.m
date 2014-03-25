//
//  DirectionGiver.m
//  msu_map
//
//  Created by Pham Khac Minh on 2/18/14.
//  Copyright (c) 2014 Minh Pham. All rights reserved.
//

#import "DirectionGiver.h"
#import "Segment.h"
#import "SegmentHandler.h"
#import "SegmentHelper.h"

@implementation DirectionGiver {
    SegmentHandler* segHandler;
    SegmentHelper* segHelper;
    int currSegInx; // index of segment the current location is on right now
    int currPointInx; // index in the current segment of the current location
}

@synthesize directionString;
@synthesize currLat;
@synthesize currLong;

-(id) initWithSegHandler:(SegmentHandler *)aSegHandler
{
    segHandler = aSegHandler;
    segHelper = [SegmentHelper alloc];
    currSegInx = [[segHandler getAllSegments] count] - 1;
    currPointInx = [[[[segHandler getAllSegments] lastObject] getPath] count] - 1;
    directionString = @"Direction not ready";
    currLat = 0;
    currLong = 0;
    
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
    currLat = latitude;
    currLong = longitude;
    
    int newSegInx = 0;
    int newPointInx = 0;
    
    int i = (int)[segHandler count] - 1 ;
    
    // looping throught the entire segment array
    // TODO: improve performance by looking at only a subset of segments
    for (; i>=0; i--)
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
        [self updateDirectionWithSegment];
        return UpdateStatusBar;
    }
    else if (newPointInx == 0)
    {
        directionString = @"End path";
        currSegInx = newSegInx;
        currPointInx = 1;
        return ChangePath;
    }
    else {
        directionString = @"Wrong path";
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

// Check if the direction giver already get update once for the current location yet or not
- (bool) hasCurrentLocation
{
    return currLat != 0 && currLong != 0;
}

// update direction string based on current Segment
- (void) updateDirectionWithSegment
{
    assert(currPointInx >= 1);
    Segment* currSeg = [[segHandler getAllSegments] objectAtIndex:currSegInx];
    
    double segLength = [currSeg getLengthTillIndex:currPointInx];
    double endLat = [[[currSeg getPath] objectAtIndex:currPointInx] doubleValue];
    double endLong = [[[currSeg getPath] objectAtIndex:currPointInx - 1] doubleValue];
    segLength += [segHelper computeDistanceWithLat:endLat long:endLong
                                            andLat:[currLat doubleValue] long:[currLong doubleValue]];
    
    NSNumber* bearing = [self convertBearingToClock:[currSeg bearingToNextSegment]];
    directionString = [[NSString alloc] initWithFormat:@"In %d feet, head toward %@ o'clock", (int)segLength, bearing];
}

@end
