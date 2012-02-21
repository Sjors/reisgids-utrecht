//
//  LocationController.h
//  Utrecht Gids
//
//  Created by Sjors Provoost on 21-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (LocationController *)initWithRootViewController:(UIViewController *)rootViewController;

@end
