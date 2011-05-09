@class UIViewController;
@class UITextField;
@class NSString;
@class AnnotationAddController;
@protocol NSObject;
@protocol UITextFieldDelegate;

@protocol AnnotationAddDelegate <NSObject>

// annotationTitle == nil on cancel
- (void)annotationAddController:
        (AnnotationAddController *)annotationAddController
        didAddAnnotationTitle:(NSString *)title;
@end

@interface AnnotationAddController: UIViewController <UITextFieldDelegate>
{
    UITextField *annotationTextField;
    id<AnnotationAddDelegate> delegate;
}

@property (nonatomic, assign) id<AnnotationAddDelegate> delegate;

- (void)initMainView;
- (void)initTextField;
- (void)didEndEditing;

// Actions: delegate method wrappers
// after pressing cancel on the navigation bar
- (void)cancelEditing:(id)sender;
// after pressing done on the navigation bar
- (void)doneEditing:(id)sender;
@end
