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

- (CGFloat) getBearingFrom:(CGPoint)startPoint intersect:(CGPoint)intersection to:(CGPoint)endPoint
{
    CGPoint relativeStartPoint = CGPointMake(startPoint.x - intersection.x, startPoint.y - intersection.y);
    CGPoint relativeEndPoint = CGPointMake(endPoint.x - intersection.x, endPoint.y - intersection.y);
    float bearingStart = atan2f(relativeStartPoint.y, relativeStartPoint.x);
    float bearingEnd = atan2f(relativeEndPoint.y, relativeEndPoint.x);
    float bearingRadian = bearingEnd - bearingStart;
    float bearingDegrees = bearingRadian * 180 / M_PI;
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

@end
