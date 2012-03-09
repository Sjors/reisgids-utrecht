//
//  Waypoint.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 20-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "Waypoint.h"


@implementation Waypoint

@dynamic lat;
@dynamic lon;
@dynamic position;
@dynamic identifier;
@dynamic range;
@dynamic last_visited_at;
@dynamic title;
@dynamic intro;
@dynamic picture_name;
@dynamic is_sight;
@dynamic links;

+(NSArray *)allSightsAfter:(Waypoint *)currentWaypoint managedObjectContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"is_sight = %d and position > %@", YES, currentWaypoint.position]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"range" ascending:YES]; 
    
    [fetch setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;
    return [moc executeFetchRequest:fetch error:&error];
}

+(NSArray *)allSightsBefore:(Waypoint *)currentWaypoint managedObjectContext:(NSManagedObjectContext *)moc {
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"is_sight = %d and position < %@", YES, currentWaypoint.position]];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"range" ascending:YES]; 
    
    [fetch setSortDescriptors:[NSArray arrayWithObject:sort]];
    
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

    // Is the current waypoint within range?
    if([currentWaypoint.is_sight boolValue] && [currentWaypoint.location distanceFromLocation:location] < [currentWaypoint.range intValue]) {
        return currentWaypoint;
    }
    
    // Go through all other waypoints in the following order:
    // * all sights after the current one, ordered by "range" (so that overlapping sights with large ranges don't take precendence)
    // * all sights before the current one (same order as above)
    // Pick the first sight within range
    
    for(Waypoint *waypoint in [self allSightsAfter:currentWaypoint managedObjectContext:moc]) {
        if ([waypoint.location distanceFromLocation:location] < [waypoint.range intValue]) {
            return waypoint;
        }
    }
    
    for(Waypoint *waypoint in [self allSightsBefore:currentWaypoint managedObjectContext:moc]) {
        if ([waypoint.location distanceFromLocation:location] < [waypoint.range intValue]) {
            return waypoint;
        }
    }
    
    // No waypoints in range:
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

}

@end
