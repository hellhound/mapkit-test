#import "AnnotationAddController.h"

@class UIViewController;
@class CLLocationManager;
@class CLLocation;
@class MKMapView;
@protocol MKMapViewDelegate;
@protocol AnnotationAddDelegate;
@protocol UIAlertViewDelegate;

@interface MapTestController: UIViewController <UIAlertViewDelegate, 
    MKMapViewDelegate, AnnotationAddDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    MKMapView *testMapView;
    BOOL needAddingAnnotation;
}

- (void)initBars;
- (void)initMainView;
- (void)initMapView;
- (void)addAnnotation;

// Actions
- (void)toggleUserAnnotation:(id)sender;
- (void)validateBeforeAddingAnnotation:(id)sender;
@end
