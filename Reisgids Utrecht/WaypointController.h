//
//  WaypointController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Waypoint.h"

@class WaypointViewController;

@interface WaypointController : NSObject <UIPageViewControllerDataSource, NSFetchedResultsControllerDelegate, UIPageViewControllerDelegate>
- (WaypointViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
- (NSUInteger)indexOfViewController:(WaypointViewController *)viewController;


@end
