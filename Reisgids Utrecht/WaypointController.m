//
//  WaypointController.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "WaypointController.h"

#import "WaypointViewController.h"
#import "AppDelegate.h"

/*
 A controller object that manages a .....
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

//@interface WaypointController()
//@property (readonly, strong, nonatomic) NSArray *pageData;
//@end

@implementation WaypointController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        [self createFetchedResultsController];
    }
    return self;
}

- (WaypointViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    int n = [[self.fetchedResultsController fetchedObjects] count];
    
    // Return the data view controller for the given index.
    if ((n == 0) || (index >= n)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WaypointViewController *waypointViewController = [storyboard instantiateViewControllerWithIdentifier:@"WaypointViewController"];
    waypointViewController.waypoint = [[self.fetchedResultsController fetchedObjects] objectAtIndex:index];
    waypointViewController.currentPage = index;
    waypointViewController.numberOfPages = n;
    return waypointViewController;
}


-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    Waypoint *waypoint = ((WaypointViewController *)[pageViewController.viewControllers objectAtIndex:0]).waypoint;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTurned" object:nil userInfo:[NSDictionary dictionaryWithObject:waypoint.position forKey:@"waypoint_pos"]];
}

- (NSUInteger)indexOfViewController:(WaypointViewController *)viewController
{   
    /*
     Return the index of the given data view controller.

     */
    return [[self.fetchedResultsController fetchedObjects] indexOfObject:viewController.waypoint];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(WaypointViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(WaypointViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [[self.fetchedResultsController fetchedObjects] count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

-(void)createFetchedResultsController {  
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.fetchedResultsController performFetch:nil];
    self.fetchedResultsController.delegate = self;    
}

#pragma mark - NSFetchedResultController delegates
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Waypoint" inManagedObjectContext:self.managedObjectContext];
    
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"position" ascending:YES]; 
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil 
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    
    return _fetchedResultsController;    
    
}


@end
