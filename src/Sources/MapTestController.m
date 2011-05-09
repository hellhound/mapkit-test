#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "MapTestController.h"

@implementation MapTestController

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [locationManager setDelegate:nil];
    [locationManager release];
    locationManager = nil;
    [currentLocation release];
    currentLocation = nil;
    [testMapView setDelegate:nil];
    [testMapView release];
    testMapView = nil;
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
    UIBarButtonItem *spacerItem = [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:nil action:nil] autorelease];
    UIBarButtonItem *annotationButtonItem = [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAction
            target:self action:@selector(toggleUserAnnotation:)] autorelease];
    UIBarButtonItem *composeButtonItem = [[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
            target:self
            action:@selector(validateBeforeAddingAnnotation:)] autorelease];

    [self setToolbarItems:[NSArray arrayWithObjects:
            annotationButtonItem, spacerItem, composeButtonItem, nil]];
}

- (void)initMainView
{
    UIView *view = [self view];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight];
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

- (void)toggleUserAnnotation:(id)sender
{
    // Start standard location services and show the user's current location
    [testMapView setShowsUserLocation:![testMapView showsUserLocation]];
}

- (void)validateBeforeAddingAnnotation:(id)sender
{
    if (currentLocation != nil) {
        [self addAnnotation];
    } else {
        UIAlertView *alertView = [[[UIAlertView alloc]
                initWithTitle:@"Need user location"
                message:@"Do you wan't to update your current location?"
                delegate:self
                cancelButtonTitle:@"Cancel"
                otherButtonTitles:@"OK", nil] autorelease];

        [alertView show];
    }
}

- (void)addAnnotation
{
    AnnotationAddController *addController =
            [[[AnnotationAddController alloc]
                initWithNibName:nil bundle:nil] autorelease];

    [addController setDelegate:self];

    UINavigationController *navigationController =
            [[[UINavigationController alloc]
                initWithRootViewController:addController] autorelease];

    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark -
#pragma mark <UIAlertViewDelegate>

- (void)    alertView:(UIAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        needAddingAnnotation = YES;
        [self toggleUserAnnotation:self];
    }
}

#pragma mark -
#pragma mark <MKMapViewDelegate>

- (void)        mapView:(MKMapView *)mapView
  didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ([userLocation isUpdating]) {
        [currentLocation autorelease];
        currentLocation = [[userLocation location] retain];
    }
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
    if (needAddingAnnotation) {
        needAddingAnnotation = NO;
        [self addAnnotation];
    }
}

#pragma mark -
#pragma mark <AnnotationAddDelegate>

- (void)annotationAddController:
        (AnnotationAddController *)annotationAddController
        didAddAnnotationTitle:(NSString *)title
{
    [self dismissModalViewControllerAnimated:YES];
    if (title != nil && currentLocation != nil)
        [testMapView addAnnotation:[[[MapAnnotation alloc]
                initWithCoordinate:[currentLocation coordinate]
                title:title] autorelease]];
}
@end
