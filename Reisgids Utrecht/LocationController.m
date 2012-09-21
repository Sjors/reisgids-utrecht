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
        
        // First application run: get location
        self.locationManager.distanceFilter = 300;
        [self.locationManager startUpdatingLocation];
        
        // Monitor when the user or system turns the page:
        [[NSNotificationCenter defaultCenter] addObserverForName:@"pageTurned" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
                        
            Waypoint *waypoint = [Waypoint findByPosition:[notif.userInfo objectForKey:@"waypoint_pos"] managedObjectContext:self.managedObjectContext];
            
            Waypoint *nextWaypoint = [waypoint next:self.managedObjectContext];
            
            if([waypoint.gps boolValue] && nextWaypoint != nil) {
               self.locationManager.distanceFilter = MAX([nextWaypoint.range intValue],30);
               [self.locationManager startUpdatingLocation];
//                NSLog(@"GPS on");
            } else if (nextWaypoint == nil) {
                // End of the tour
                [self.locationManager stopUpdatingLocation];
//                NSLog(@"GPS off");
            } else {
                // We're at a sight where the user manually needs to flip the page to continue his tour.  
                [self.locationManager stopUpdatingLocation];
//                NSLog(@"GPS off");
            }            
        }] ;
        
        
//        // Monitor when the user flips to info view
//        [[NSNotificationCenter defaultCenter] addObserverForName:@"infoScreen" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
//                     
//            self.locationManager.distanceFilter = 500;
//            [self.locationManager startUpdatingLocation];
//        }] ;
    };
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //NSLog(@"We're here: %@", [newLocation description]);
    
    // Check if it's recent (2 minutes)
    if([newLocation.timestamp timeIntervalSinceNow] < -120) return;
    
    // Which waypoint is the user looking at?
    Waypoint *currentWaypoint = ((WaypointViewController *)[self.rootViewController.pageViewController.viewControllers objectAtIndex:0]).waypoint;
    
    
    // Should we mark any waypoint as visited?
    Waypoint *nearestWaypointInRange = [Waypoint findNearestWaypointInRangeStartingWith:currentWaypoint location:newLocation managedObjectContext:self.managedObjectContext];
    
    if(nearestWaypointInRange!=nil && ( [nearestWaypointInRange.last_visited_at compare:[[NSDate date] dateByAddingTimeInterval:-3600]] == NSOrderedAscending || nearestWaypointInRange.last_visited_at == nil)) {
        [nearestWaypointInRange markVisited:self.managedObjectContext];
        
        // Turn page to that waypoint:
        if([nearestWaypointInRange.identifier intValue] != [currentWaypoint.identifier intValue]) {
            [self.rootViewController turnToPageForWaypoint:nearestWaypointInRange];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTurned" object:nil userInfo:[NSDictionary dictionaryWithObject:nearestWaypointInRange.position forKey:@"waypoint_pos"]];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // What happened?
    
    // Did we not get authorization?
    
        // We don't care
    
    
}



@end
