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
@dynamic title;
@dynamic intro;
@dynamic picture_name;
@dynamic is_sight;

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

@end
