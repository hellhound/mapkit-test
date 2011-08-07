#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnnotationAddController.h"

#define REFERENCE_SCREEN_WIDTH 320.0
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCALE_FACTOR SCREEN_WIDTH / REFERENCE_SCREEN_WIDTH
#define TEXT_FIELD_HEIGHT 30.0
#define TEXT_FIELD_WIDTH 260.0
#define TEXT_FIELD_TOP_MAGIN 10 * SCALE_FACTOR

NSString *kPlaceHolder = @"Your annotation";

#pragma mark -
#pragma mark static

static BOOL isPad()
{
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

@implementation AnnotationAddController

#pragma mark -
#pragma mark NSObject

- (void)dealloc
{
    delegate = nil;
    [annotationTextField release];
    annotationTextField = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    if ((self = [super initWithNibName:nibName bundle:bundle]) != nil)
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    return self; 
}

- (UINavigationItem *)navigationItem
{
    UINavigationItem *navItem = [super navigationItem];

    [navItem setTitle:@"Add Annotation"];
    [navItem setLeftBarButtonItem:
            [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                    target:self action:@selector(cancelEditing:)] autorelease]];
    [navItem setRightBarButtonItem:
            [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                    target:self action:@selector(doneEditing:)] autorelease]];
    return navItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView]; 
    [self initTextField];
    [[self view] sizeToFit];
}

#pragma mark -
#pragma mark annotationAddController

@synthesize delegate;

- (void)initMainView
{
    UIView *view = [self view];

    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight];
}

- (void)initTextField
{
    UIView *superView = [self view];
    CGSize superViewSize = [superView bounds].size;

    annotationTextField = [[UITextField alloc] initWithFrame:
            CGRectMake((superViewSize.width - TEXT_FIELD_WIDTH) / 2,
                TEXT_FIELD_TOP_MAGIN, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)]; 
    [annotationTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [annotationTextField setTextColor:[UIColor blackColor]];
    [annotationTextField setFont:[UIFont systemFontOfSize:17.0]];
    [annotationTextField setPlaceholder:kPlaceHolder];
    [annotationTextField setBackgroundColor:[UIColor whiteColor]];
    [annotationTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [annotationTextField setKeyboardType:UIKeyboardTypeDefault];
    [annotationTextField setReturnKeyType:UIReturnKeyDone];
    [annotationTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [annotationTextField setDelegate:self];
    [annotationTextField becomeFirstResponder];
    [superView addSubview:annotationTextField];
}

- (void)didEndEditing
{
    NSString *text = [annotationTextField text];

    if ([@"" isEqualToString:[text stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) 
        return;
    if (delegate != nil)
        [delegate annotationAddController:self didAddAnnotationTitle:text];
}

- (void)cancelEditing:(id)sender
{
    if (delegate != nil)
        [delegate annotationAddController:self didAddAnnotationTitle:nil];
}

- (void)doneEditing:(id)sender
{
    [self didEndEditing];
}

#pragma mark -
#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([@"" isEqualToString:[[textField text] stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) 
        return NO;
    // the user pressed the "Done" button, so dismiss the keyboard
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self didEndEditing];
}
@end
