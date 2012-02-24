//
//  RootViewController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "Waypoint.h"

@class LocationController;

@interface RootViewController : UIViewController <UIPageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) LocationController *locationController;

-(void)turnToPageForWaypoint:(Waypoint *)waypoint;

@end
