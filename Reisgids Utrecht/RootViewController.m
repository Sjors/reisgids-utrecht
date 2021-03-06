//
//  RootViewController.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "RootViewController.h"

#import "WaypointController.h"

#import "WaypointViewController.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) WaypointController *waypointController;
@end

@implementation RootViewController

@synthesize pageViewController = _pageViewController;
@synthesize waypointController = _waypointController;
@synthesize locationController = _locationController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    WaypointViewController *startingViewController = [self.waypointController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = [NSArray arrayWithObject:startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    self.pageViewController.dataSource = self.waypointController;
    self.pageViewController.delegate = self.waypointController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];    

    // iOs 5 specific:
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    }
    

    
    self.locationController = [[LocationController alloc] initWithRootViewController:self];
    
    // iOs 5 specific:
     if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {        
        for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
            gR.delegate = self;
        }
    } else {
        // http://stackoverflow.com/a/10467686/313633
        // Disable tap gesture; only swipe.
                
        UIGestureRecognizer* tapRecognizer = nil;
        for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers) {
            if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
                tapRecognizer = recognizer;
                break;
            }
        }
        
        if ( tapRecognizer ) {
            [self.view removeGestureRecognizer:tapRecognizer];
            [self.pageViewController.view removeGestureRecognizer:tapRecognizer];
        }
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
     if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            CGPoint touchPoint = [touch locationInView:self.view];
            if (touchPoint.x > 50 && touchPoint.x < 430) {//Let the buttons in the middle of the top bar receive the touch
                return NO;
            }
        }
        return YES;
    } else {
        return YES; // The default according to documentation
    }
    

}

-(void)turnToPageForWaypoint:(Waypoint *)waypoint {
    WaypointViewController *vc = [self.waypointController viewControllerAtIndex:[waypoint.position intValue] storyboard:self.storyboard];
    
    NSArray *viewControllers = [NSArray arrayWithObject:vc];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (WaypointController *)waypointController
{
    /*
     Return the model controller object, creating it if necessary.
     In more complex implementations, the model controller may be passed to the view controller.
     */
    if (!_waypointController) {
        _waypointController = [[WaypointController alloc] init];
    }
    return _waypointController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end
