//
//  AppDelegate.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "AppDelegate.h"
#import "Waypoint.h"
#import "Link.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
//    // This will later be replaced by the code in persistentStoreCoordinator and the prefill bundle, which in turn will get the data from a server.
//    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
//    [fetch setEntity:[NSEntityDescription entityForName:@"Waypoint" inManagedObjectContext:self.managedObjectContext]];
//    
//    NSError *error = nil;
//    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetch error:&error];
//    
//    if(count == 0) {
//        // Insert initial data:
//        Waypoint *waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:0];
//        waypoint.title = @"Spoorwegmuseum";
//        waypoint.intro = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
//        waypoint.picture_name = @"Spoorwegmuseum";    
//        waypoint.is_sight = [NSNumber numberWithBool:YES];
//        waypoint.lat = [NSNumber numberWithFloat:52.088004];
//        waypoint.lon = [NSNumber numberWithFloat:5.130816];
//        waypoint = nil;
//    
//        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:1];
//        waypoint.title = @"Richting brug";
//        waypoint.intro = @"Met je rug naar het spoorwegmuseum zie je achter de boom al de Dom. Loop rechtdoor en over de brug.";
//        waypoint.picture_name = @"VanafSpoorwegmuseum";   
//        waypoint.lat = [NSNumber numberWithFloat:52.088004];
//        waypoint.lon = [NSNumber numberWithFloat:5.130816];
//        
//        waypoint = nil;
//        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:2];
//        waypoint.title = @"Volg de stoep naar links";
//        waypoint.intro = @"Geniet van het uitzicht vanaf de brug en over het Lepelenburg. Sla linksaf en volg de stoep aan de rechterkant.";
//        waypoint.picture_name = @"LepelenburgLinksaf";  
//        waypoint.lat = [NSNumber numberWithFloat:52.088729];
//        waypoint.lon = [NSNumber numberWithFloat:5.128502];
//        
//        waypoint = nil;
//        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:3];
//        waypoint.title = @"Bruntenhof";
//        waypoint.intro = @"Schattige huisjes toch? Loop nu de Schalkwijkstraat door.";
//        waypoint.picture_name = @"Bruntenhof";   
//        waypoint.is_sight = [NSNumber numberWithBool:YES];
//        waypoint.lat = [NSNumber numberWithFloat:52.088128];
//        waypoint.lon = [NSNumber numberWithFloat:5.127861];
//
//        waypoint = nil;
//        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:4];
//        waypoint.title = @"Rechtsaf langs de Nieuwegracht";
//        waypoint.intro = @"De verleiding is groot om langs de kant van het water te lopen. Weersta die: er ligt nog wel eens hondenpoep.";
//        waypoint.picture_name = @"NieuwegrachtRechtsaf";   
//        waypoint.lat = [NSNumber numberWithFloat:52.087447];
//        waypoint.lon = [NSNumber numberWithFloat:5.126013];
//        
//        waypoint = nil;
//        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
//        waypoint.position = [NSNumber numberWithInt:5];
//        waypoint.title = @"Held op dak";
//        waypoint.intro = @"Aan de overkant zie je een beeld van een sterke man op het dak.";
//        waypoint.picture_name = @"NieuweGrachtManOpDak";   
//        waypoint.is_sight = [NSNumber numberWithBool:YES];
//        waypoint.lat = [NSNumber numberWithFloat:52.08935];
//        waypoint.lon = [NSNumber numberWithFloat:5.124206];
//        
////        waypoint = nil;
////        
////        waypoint = [NSEntityDescription insertNewObjectForEntityForName:@"Waypoint"  inManagedObjectContext:self.managedObjectContext];
////        waypoint.position = [NSNumber numberWithInt:0];
////        waypoint.title = @"";
////        waypoint.intro = @"";
////        waypoint.picture_name = @"";   
//        
//        [self saveContext];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"reisgids-utrecht.sqlite"];
    
    // Check if file already exists, if not, copy it from bundle:
    if(![storeURL checkResourceIsReachableAndReturnError:nil]) {
        NSString *prefillStorePath = [[NSBundle mainBundle] pathForResource:@"Prefill Bundle" ofType:@"sqlite"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error = nil;
        [fileManager copyItemAtPath:prefillStorePath toPath:[storeURL path] error:&error];
        
        if(error != nil) {
            NSLog(@"Error copying database: %@]", [error description]);
        }
        
    }
    
    
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
    
    return persistentStoreCoordinator;
}

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
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


# pragma mark Other
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
