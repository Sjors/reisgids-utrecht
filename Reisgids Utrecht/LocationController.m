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
#import "WaypointViewController.h"

@implementation LocationController

@synthesize managedObjectContext=_managedObjectContext;
@synthesize locationManager=_locationManager;
@synthesize rootViewController=_rootViewController;

- (LocationController *)initWithRootViewController:(RootViewController *)rootViewController {
    
    if((self = [super init])) {
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        self.rootViewController = rootViewController;
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.purpose = @"De gids werkt ook zonder, maar kan je beter helpen met navigeren en voorbereiden als je locatie bekend is.";
        
        // Monitor when the user or system turns the page:
        [[NSNotificationCenter defaultCenter] addObserverForName:@"pageTurned" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
            
            applicationMode = kApplicationModeDefault;
            
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

                [self.locationManager stopUpdatingLocation];
            } else {
                NSLog(@"This shoudn't happen");
            }
            
            
            
        }] ;
        
        
        // Monitor when the user flips to info view
        [[NSNotificationCenter defaultCenter] addObserverForName:@"infoScreen" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
            
            applicationMode = kApplicationModeInfoScreen;
         
            self.locationManager.distanceFilter = 500;
            [self.locationManager startUpdatingLocation];
        }] ;
    };
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"We're here: %@", [newLocation description]);
    
    // Check if it's recent (2 minutes)
    if([newLocation.timestamp timeIntervalSinceNow] < -120) return;
    
    // Figure out why we need it...
    
    // Which waypoint is the user looking at?
    Waypoint *currentWaypoint = ((WaypointViewController *)[self.rootViewController.pageViewController.viewControllers objectAtIndex:0]).waypoint;
    
    if(applicationMode == kApplicationModeInfoScreen) {
        // Nothing to do
    } else {
    
        // How far are we from the next waypoint?
        Waypoint *nextWaypoint = [currentWaypoint next:self.managedObjectContext];
        
        if(nextWaypoint != nil) {
            NSInteger distance = [newLocation distanceFromLocation:nextWaypoint.location];
            
            NSLog(@"Distance to next waypoint: %d meters.", distance);
            
            // What do we do with it
            
            // Flip the page is we are less than 30 meters from the next waypoint
            if (distance < 30) {
                [self.rootViewController turnToPageForWaypoint:nextWaypoint];
            }
            
        } else {
            NSLog(@"We're already at the last waypoint. This shouldn't happen.");
        }
        
    }

    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // What happened?
    
    // Did we not get authorization?
    
        // We don't care
    
    
}



@end
