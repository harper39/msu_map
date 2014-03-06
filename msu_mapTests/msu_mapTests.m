//
//  msu_mapTests.m
//  msu_mapTests
//
//  Created by Minh Pham on 10/11/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "msu_mapTests.h"

#import "JSONParser.h"
#import "SegmentHandler.h"
#import "Segment.h"

@implementation msu_mapTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) testQuery
{
    JSONParser *parse = [JSONParser alloc];
    SegmentHandler *segHandler = [parse getTestSegment];
    if (segHandler) NSLog(@"Successful retrieve segments from server");
    else STFail(@"Unsuccessful query");

    [segHandler trimSegment];
}

@end
