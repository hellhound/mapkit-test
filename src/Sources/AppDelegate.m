/*-----------------------------------------------------------------------------
** This software is in the public domain, furnished "as is", without technical 
** support, and with no warranty, express or implied, as to its usefulness for
** any purpose.
**----------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapTestController.h"
#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    [window release];
    [tabBarController release];
    [tabs release];
    [super dealloc];
}

#pragma mark -
#pragma mark AppDelegate

- (void)addMapTest
{
    MapTestController *mapController = [[[MapTestController alloc]
            initWithNibName:nil bundle:nil] autorelease];
    UINavigationController *navigationController =
            [[[UINavigationController alloc] initWithRootViewController:
                mapController] autorelease];

    // setting navigation and tool bars styles
    [[navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[navigationController toolbar] setBarStyle:UIBarStyleBlack];
    // show the toolbar
    [navigationController setToolbarHidden:NO];
    [tabs addObject:navigationController];
}

- (void)initializeUI
{
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabBarController =
            [[UITabBarController alloc] initWithNibName: nil bundle:nil];
    tabs = [[NSMutableArray array] retain];
    [self addMapTest];
    [self addMapTest];
    [self addMapTest];
    [self addMapTest];
    [tabBarController setViewControllers:tabs];
    [window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
}

#pragma mark -
#pragma mark <UIApplicationDelegate>

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)withOptions
{
    [self initializeUI];
    return YES;
}
@end
