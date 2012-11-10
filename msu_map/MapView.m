//
//  MapView.m
//  msu_map
//
//  Created by Minh Pham on 11/10/12.
//  Copyright (c) 2012 Minh Pham. All rights reserved.
//

#import "MapView.h"

@implementation MapView{
    MKMapView *mapView; // the map view from mapkit
    CurrentLocation *currLoc; // the current location
}

/*! Constructor
 * \param window the window this mapview live in
 */
- (id) init:(UIViewController *)window{
    if(!(self = [super init]))
        return nil;
    mapView = [[MKMapView alloc] initWithFrame:window.view.bounds];
    mapView.mapType = MKMapTypeStandard;
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    mapView.delegate = self;
    
    // Zoom to MSU's campus
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.015;
    span.longitudeDelta = 0.015;
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(42.723244, -84.482544);
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
    
    [window.view addSubview:mapView];
    
    return self;
}

// Use delegate pattern to draw the overlay (route)
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay> )overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView* view = [[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay];
        view.fillColor   = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        view.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        view.lineWidth = 3;
        return view;
    }
    else if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView* view = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
        view.lineWidth = 5;
        view.strokeColor = [UIColor blueColor];
        return view;
    }
    else return nil;
}


// Add an overlay of route using array of points
// to the existing map view
- (void) addOverlayArray: (NSArray *) path
{
    CLLocationCoordinate2D pathCoords[[path count]/2];
    //NSLog(@"[path count]: %i", [path count]);
    
    for(int i=0; i<[path count]/2; i++)
        pathCoords[i] = CLLocationCoordinate2DMake([[path objectAtIndex:2*i+1] doubleValue], [[path objectAtIndex:2*i] doubleValue]);
    
    MKPolyline* pathPolyline = [MKPolyline polylineWithCoordinates:pathCoords count:[path count]/2];
    
    [mapView addOverlay:pathPolyline];
    //NSLog(@"reach here");
}

@end
