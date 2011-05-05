#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@implementation MapAnnotation

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [title release];
    [coordinate release];
    [super dealloc];
}

#pragma mark -
#pragma mark MapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)fromCoordinate
                   title:(NSString *)fromTitle
{
    if ((self = [super init]) != nil) {
        coordinate = [[NSData alloc] initWithBytes:&fromCoordinate
                length:sizeof(CLLocationCoordinate2D)];
        title = [fromTitle copy];
    }
    return self;
}

#pragma mark -
#pragma mark <MKAnnotation>

- (CLLocationCoordinate2D)coordinate
{
    return coordinate != nil ? *(CLLocationCoordinate2D *)[coordinate bytes] :
            (CLLocationCoordinate2D){0};
}
@end
