//
//  Link.m
//  Utrecht Gids
//
//  Created by Sjors Provoost on 07-03-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "Link.h"
#import "Waypoint.h"


@implementation Link

@dynamic identifier;
@dynamic title;
@dynamic url;
@dynamic match;
@dynamic waypoint;

+(Link *)findByUrl:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Link" inManagedObjectContext:moc]];
    
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"url = %@", [url absoluteString]]];
    
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

+(Link *)findById:(NSNumber *)identifier managedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Link" inManagedObjectContext:moc]];
    
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


@end
