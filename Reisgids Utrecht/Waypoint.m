//
//  Waypoint.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 20-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "Waypoint.h"
#import "MixpanelAPI.h"


@implementation Waypoint

@dynamic lat;
@dynamic lon;
@dynamic position;
@dynamic identifier;
@dynamic range;
@dynamic gps;
@dynamic last_visited_at;
@dynamic title;
@dynamic intro;
@dynamic picture_name;
@dynamic is_sight;
@dynamic links;

+(NSArray *)allWaypointsAfter:(Waypoint *)currentWaypoint managedObjectContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"position > %@", currentWaypoint.position]];
    
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] 
                              initWithKey:@"range" ascending:YES]; 
    
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] 
                               initWithKey:@"position" ascending:YES]; 
    
    [fetch setSortDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]];
    
    NSError *error = nil;
    return [moc executeFetchRequest:fetch error:&error];
}

+(NSArray *)allWaypointsBefore:(Waypoint *)currentWaypoint managedObjectContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"position < %@", currentWaypoint.position]];
    
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] 
                               initWithKey:@"range" ascending:NO]; 
    
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] 
                               initWithKey:@"position" ascending:NO]; 
    
    [fetch setSortDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]];
    
    NSError *error = nil;
    return [moc executeFetchRequest:fetch error:&error];
}


+(Waypoint *)findByPosition:(NSNumber *)position managedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"position = %@", position]];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetch error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        //
        if (count > 0) {
            return [array objectAtIndex:0];
        } else {
            // Deal with error.
        }
    }
    else {
        // Deal with error.
    }
    
    return nil;
}
+(Waypoint *)findById:(NSNumber *)identifier managedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", identifier]];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetch error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        //
        if (count > 0) {
            return [array objectAtIndex:0];
        } else {
            // Deal with error.
        }
    }
    else {
        // Deal with error.
    }
    
    return nil;
}



-(CLLocation *)location {
    CLLocationDegrees lat = [self.lat doubleValue];
    CLLocationDegrees lon = [self.lon doubleValue];

    return [[CLLocation alloc]initWithLatitude:lat longitude:lon];
}

-(Waypoint *)next:(NSManagedObjectContext *)moc {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"position = %d", [self.position intValue] + 1]];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetch error:&error];
    if (array != nil) {
        NSUInteger count = [array count];      
        if (count > 0) {
            return [array objectAtIndex:0];
        } else {
            // Last waypoint
            return nil;
        }
    }
    else {
        // Deal with error.
    }
    
    return nil;
}

+(Waypoint *)findNearestWaypointInRangeStartingWith:(Waypoint *)currentWaypoint location:(CLLocation *)location managedObjectContext:(NSManagedObjectContext *)moc {

    // Als je bij het Spoorwegmuseum aankomt per trein, is dat de zichtbare pagina en wordt die als "bezocht" gemarkeerd. Station Maliebaan wordt pas gemarkeerd als je de pagina zelf omslaat.

    // Is the current waypoint within range and has it not been marked as visited yet?
    if([currentWaypoint.location distanceFromLocation:location] < [currentWaypoint.range intValue] && location.horizontalAccuracy <= [currentWaypoint.range intValue] && currentWaypoint.last_visited_at == nil) {
        return currentWaypoint;
    }
    
    // Go through all other waypoints in the following order:
    // * all sights after the current one, ordered by "range" (so that overlapping sights with large ranges don't take precendence)
    // * all sights before the current one (same order as above)
    // Pick the first sight within range that has not been marked as visited yet.
    
    for(Waypoint *waypoint in [self allWaypointsAfter:currentWaypoint managedObjectContext:moc]) {
        int distance = [waypoint.location distanceFromLocation:location];
//        NSLog(@"Distance to %@ is %d meters.", waypoint.title, distance);
        if (distance < [waypoint.range intValue] && location.horizontalAccuracy <= [waypoint.range intValue] && waypoint.last_visited_at == nil) {
            return waypoint;
        }
    }
    
    for(Waypoint *waypoint in [self allWaypointsBefore:currentWaypoint managedObjectContext:moc]) {
        if ([waypoint.location distanceFromLocation:location] < [waypoint.range intValue]  && location.horizontalAccuracy <= [waypoint.range intValue]  && waypoint.last_visited_at == nil) {
            return waypoint;
        }
    }
    
    // No (new) waypoints in range:
    return nil;
}

-(void)markVisited:(NSManagedObjectContext *)moc {
    self.last_visited_at = [NSDate date];
    NSError *error;
    if (![moc save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    
    if([defaults boolForKey:@"logActivity"]) {
        [mixpanel track:@"visitSight" properties:[NSDictionary dictionaryWithObjectsAndKeys:self.identifier, @"id", self.title, @"title", nil]];
    }
    


}

@end
