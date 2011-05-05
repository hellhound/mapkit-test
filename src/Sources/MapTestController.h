@class UIViewController;
@class CLLocationManager;
@class CLLocation;
@class MKMapView;
@protocol MKMapViewDelegate;

@interface MapTestController: UIViewController <MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLHeading *currentHeading;
    MKMapView *testMapView;
}

- (void)initBars;
- (void)initMapView;
- (void)toggleUserAnnotation;
@end
