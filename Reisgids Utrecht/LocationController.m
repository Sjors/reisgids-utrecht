//
//  LocationController.m
//  Utrecht Gids
//
//  Created by Sjors Provoost on 21-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "LocationController.h"
#import "Waypoint.h"
#import "AppDelegate.h"

@implementation LocationController

@synthesize managedObjectContext=_managedObjectContext;
@synthesize locationManager=_locationManager;

- (LocationController *)initWithRootViewController:(UIViewController *)rootViewController {
    
    if((self = [super init])) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // Monitor when the user or system turns the page:
        [[NSNotificationCenter defaultCenter] addObserverForName:@"pageTurned" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
            
            
            
            Waypoint *waypoint = [Waypoint findByPosition:[notif.userInfo objectForKey:@"waypoint_pos"] managedObjectContext:self.managedObjectContext];
            
            // NSLog(@"Turned the page to waypoint %@", waypoint.position);

            // Start monitoring location when user views a waypoint and the 
            // next waypoint is more than 50 meters away.

            Waypoint *nextWaypoint = [waypoint next:self.managedObjectContext];
            
            if(nextWaypoint != nil && [waypoint.location distanceFromLocation:nextWaypoint.location] > 50) {
                self.locationManager.distanceFilter = 30;
                [self.locationManager startUpdatingLocation];
            } else if (nextWaypoint == nil) {
                // End of the tour
                [self.locationManager stopUpdatingLocation];
            } else if ([waypoint.location distanceFromLocation:nextWaypoint.location] <= 50) {
                // We're at a sight where the user manually needs to flip the page to continue his tour.                
            } else {
                NSLog(@"This shoudn't happen");
            }
            
            
            
        }] ;
    };
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"We're here: %@", [newLocation description]);
    
    // Check if it's recent
    
    // Figure out why we need it...
    
    // What do we do with it?
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}



@end
