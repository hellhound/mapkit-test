@class UITabBarController;
@class NSObject;
@class NSMutableArray;
@protocol UIApplicationDelegate;

@interface AppDelegate: NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UITabBarController *tabBarController;
    NSMutableArray *tabs;
}

- (void)addMapTest;
- (void)initializeUI;
@end
