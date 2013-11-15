//
//  SegmentHandler.m
//  msu_map
//
//  Created by Pham Khac Minh on 10/5/13.
//  Copyright (c) 2013 Minh Pham. All rights reserved.
//

#import "SegmentHandler.h"
#include "Segment.h"

@implementation SegmentHandler { 
    NSArray* segmentArray;
}


- (id) initWithGeometry:(NSArray *)geometry
{
    NSMutableArray* segments = [[NSMutableArray alloc] initWithCapacity:[geometry count]];
    for(int i=0; i<[geometry count]; i++)
    {
        Segment* tempSeg = [[Segment alloc] initWithJSON:[geometry objectAtIndex:i]];
        [segments addObject:tempSeg];
    }
    segmentArray = segments;
    return self;
}

- (NSArray*) getPath
{
    NSMutableArray* path = [[NSMutableArray alloc] init];
    for(int i=0; i<[segmentArray count]; i++)
    {
        [path addObjectsFromArray:[[segmentArray objectAtIndex:i] getPath]];
    }
    return path;
}

// Compute the bearing
- (CGFloat) getBearingFrom:(CGPoint)startPoint intersect:(CGPoint)intersection to:(CGPoint)endPoint
{
    // compute bearing relative to start point
    CGPoint relativeStartPoint = CGPointMake(startPoint.x - intersection.x, startPoint.y - intersection.y);
    // check if the start point and intersection are the same
    if (relativeStartPoint.x == 0 && relativeStartPoint.y == 0) return NZERO;
    float bearingStart = atan2f(relativeStartPoint.y, relativeStartPoint.x);
    if (relativeStartPoint.x < 0) bearingStart = M_PI * 2 - bearingStart;
    
    // Compute bearing relate to end point
    CGPoint relativeEndPoint = CGPointMake(endPoint.x - intersection.x, endPoint.y - intersection.y);
    // check if the start point and intersection are the same
    if (relativeEndPoint.x == 0 && relativeEndPoint.y == 0) return NZERO;
    float bearingEnd = atan2f(relativeEndPoint.y, relativeEndPoint.x);
    if (relativeEndPoint.x < 0) bearingEnd = M_PI * 2 - bearingEnd;
    
    float bearingRadian = bearingEnd - bearingStart;
    float bearingDegrees = bearingRadian * 180 / M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

// Compute bearing and change it to clock format
- (NSNumber*) getClockBearing:(CGPoint)from intersect:(CGPoint)mid to:(CGPoint)to
{
    float bearingDegrees = [self getBearingFrom:from intersect:mid to:to];
    // intersection is the same as start or end point
    if (bearingDegrees == NZERO) return NULL;
    
    int clock = (int) (bearingDegrees + 15) / 30;
    clock = 12 - (clock + 6) % 12;
    return [NSNumber numberWithInt:clock];
}


@end
