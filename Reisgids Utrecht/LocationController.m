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
#import <AudioToolbox/AudioServices.h>

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
            
            int distance;
            if(nextWaypoint != nil) {
                distance = [waypoint.location distanceFromLocation:nextWaypoint.location];
                NSLog(@"Distance between waypoints: %d", distance);
            }
            
            if(nextWaypoint != nil && distance > 65) { // Spoorwegmuseum en station Maliebaan liggen nu 61 meter uit elkaar
                self.locationManager.distanceFilter = [nextWaypoint.range intValue];
                [self.locationManager startUpdatingLocation];
            } else if (nextWaypoint == nil) {
                // End of the tour
                [self.locationManager stopUpdatingLocation];
            } else if (distance <= 65) {
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
    
    
    // Should we mark any waypoint as visited?
    Waypoint *nearestWaypointInRange = [Waypoint findNearestWaypointInRangeStartingWith:currentWaypoint location:newLocation managedObjectContext:self.managedObjectContext];
    
    if(nearestWaypointInRange!=nil && ( [nearestWaypointInRange.last_visited_at compare:[[NSDate date] dateByAddingTimeInterval:-3600]] == NSOrderedAscending || nearestWaypointInRange.last_visited_at == nil)) {
        [nearestWaypointInRange markVisited:self.managedObjectContext];
    }
    
    
    
    if(applicationMode == kApplicationModeInfoScreen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdate" object:nil userInfo:nil];
    } else {
    
        // How far are we from the next waypoint?
        Waypoint *nextWaypoint = [currentWaypoint next:self.managedObjectContext];
        
        if(nextWaypoint != nil) {
            NSInteger distance = [newLocation distanceFromLocation:nextWaypoint.location];
            
            NSLog(@"Distance to next waypoint: %d meters.", distance);
            
            // What do we do with it
            
            // Flip the page is we are within range of the next waypoint
            if (distance < [nextWaypoint.range intValue]) {
                [self.rootViewController turnToPageForWaypoint:nextWaypoint];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
