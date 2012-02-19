//
//  WaypointController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WaypointViewController;

@interface WaypointController : NSObject <UIPageViewControllerDataSource>
- (WaypointViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(WaypointViewController *)viewController;
@end
