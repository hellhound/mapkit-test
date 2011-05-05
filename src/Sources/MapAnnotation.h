@protocol MKAnnotation;

@interface MapAnnotation: NSObject <MKAnnotation>
{
    NSString *title;
    NSData *coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)fromCoordinate
                   title:(NSString *)fromTitle;
@end
