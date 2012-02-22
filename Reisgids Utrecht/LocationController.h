//
//  LocationController.h
//  Utrecht Gids
//
//  Created by Sjors Provoost on 21-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RootViewController.h"

@class RootViewController;

@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) RootViewController *rootViewController;

- (LocationController *)initWithRootViewController:(RootViewController *)rootViewController;

@end
