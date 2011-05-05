#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapTestController.h"

@implementation MapTestController

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [locationManager setDelegate:nil];
    [locationManager release];
    [currentHeading release];
    [testMapView setDelegate:nil];
    [testMapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    if ((self = [super initWithNibName:nibName bundle:bundle]) != nil) {
        [self initBars];
        [self setTitle:@"Map Test"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMapView];
    [[self view] sizeToFit];
}

#pragma mark -
#pragma mark MapTestController

- (void)initBars
{
    // Configuring tab bar item
    [self setTabBarItem:[[[UITabBarItem alloc] initWithTabBarSystemItem:
            UITabBarSystemItemSearch tag:0] autorelease]];

    // Setting toolbar items
    UIBarButtonItem *barItem = [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAction
            target:self action:@selector(toggleUserAnnotation)] autorelease];

    [self setToolbarItems:[NSArray arrayWithObjects:barItem, nil]];
}

- (void)initMapView
{
    UIView *superView = [self view];
    CGRect superBounds = [superView bounds];
    UINavigationController *navigationController = [self navigationController];

    // Remove excesive height
    if (navigationController != nil) {
        superBounds.size.height -=
                CGRectGetHeight([[navigationController navigationBar] frame]);
        if (![navigationController isToolbarHidden])
            superBounds.size.height -=
                    CGRectGetHeight([[navigationController toolbar] frame]);
    }
    testMapView = [[MKMapView alloc] initWithFrame:superBounds];
    //Configuring the map
    [testMapView setDelegate:self];
    [testMapView setMapType:MKMapTypeHybrid];
    [testMapView setZoomEnabled:YES];
    [testMapView setScrollEnabled:YES];
    // Adding the map to the main view
    [superView addSubview:testMapView];
}

- (void)toggleUserAnnotation
{
    // Start standard location services and show the user's current location
    [testMapView setShowsUserLocation:![testMapView showsUserLocation]];
}

#pragma mark -
#pragma mark <MKMapViewDelegate>

- (void)        mapView:(MKMapView *)mapView
  didUpdateUserLocation:(MKUserLocation *)userLocation
{
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    id<MKAnnotation> annotation =
            [(MKAnnotationView *)[views objectAtIndex:0] annotation];
    CLLocationCoordinate2D centerCoordinate = [annotation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
            centerCoordinate, 250, 250);
    [mapView setCenterCoordinate:centerCoordinate];
    [mapView setRegion:region animated:YES];
}
@end
