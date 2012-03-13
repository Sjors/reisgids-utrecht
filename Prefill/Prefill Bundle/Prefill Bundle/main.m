//
//  main.m
//  Prefill Bundle
//
//  Created by Sjors Provoost on 06-03-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#include "Waypoint.h"
#include "Link.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
//    NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
//    path = [path stringByDeletingPathExtension];
//    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
//    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

static void saveContext() {
    NSError *error = nil;
    NSManagedObjectContext *objectContext = managedObjectContext();
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        // Erase all waypoints:
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:context]];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetch error:&error];
        
        if(error!= nil) {
            NSLog(@"Error while searching %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        
        for(Waypoint *waypoint in results) {
            [context deleteObject:waypoint];
        }
        
        // Save the managed object context
        error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:
                        @"waypoints" ofType:@"plist"];
        
        NSMutableArray *waypoints = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        for (NSDictionary *waypoint_data in waypoints) {
            Waypoint *waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:context];
            waypoint.identifier = [waypoint_data valueForKey:@"id"];
            waypoint.position = [waypoint_data valueForKey:@"position"];
            waypoint.range = [waypoint_data valueForKey:@"range"];
            waypoint.title = [waypoint_data valueForKey:@"title"];
            waypoint.intro = [waypoint_data valueForKey:@"intro"];
            //waypoint.picture_name = @"Spoorwegmuseum";    
            waypoint.is_sight = [waypoint_data valueForKey:@"is_sight"]; //[NSNumber numberWithBool:YES];
            waypoint.lat = [waypoint_data valueForKey:@"latitude"]; //[NSNumber numberWithFloat:52.088004];
            waypoint.lon = [waypoint_data valueForKey:@"longitude"];
            
            for (NSDictionary *link_data in [waypoint_data valueForKey:@"links"]) {
                Link *link = [NSEntityDescription insertNewObjectForEntityForName:@"Link"  inManagedObjectContext:context];
                link.waypoint = waypoint;
                link.identifier = [link_data valueForKey:@"id"];
                link.title = [link_data valueForKey:@"title"];
                link.url = [link_data valueForKey:@"url"];
                if([link_data valueForKey:@"match"] != nil && ![(NSString *)[link_data valueForKey:@"match"] isEqualToString:@""]) {
                    link.match = [link_data valueForKey:@"match"];
                }
            }
        }
        
        // Insert waypoints

                              
        saveContext();
        
    }
    return 0;
}

