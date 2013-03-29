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
    
    // Set the application defaults on first launch
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults valueForKey:@"logActivity"] == nil) {
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES" forKey:@"logActivity"];
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
    }
    
    // Analytics (Mixpanel)
    if([defaults boolForKey:@"logActivity"]) {
#ifdef DEBUG
        [Mixpanel sharedInstanceWithToken:@"60f7d9a9f202586a0d96a63b155337a8"];
#else
        [Mixpanel sharedInstanceWithToken:@"2c4aba7e3b7f4b125fb9326dc74fa6ba"];
#endif
    }
    
    if(![defaults valueForKey:@"version"] && [[Waypoint findById:@9 managedObjectContext:self.managedObjectContext].title isEqualToString:@"Richting Dom kerk"]) {
        // Fix bugs in version 0.1
        [Waypoint findById:@9 managedObjectContext:self.managedObjectContext].title = @"Richting Domkerk";
         
        [Link findById:@48 managedObjectContext:self.managedObjectContext].match = @"App";
      
        [Link findById:@25 managedObjectContext:self.managedObjectContext].match = @"app";

        Waypoint *straatweg = [Waypoint findById:@30 managedObjectContext:self.managedObjectContext];
        straatweg.title = @"Amsterdamsestraatweg";
        straatweg.intro = [straatweg.intro stringByReplacingOccurrencesOfString:@"Amsterdamse Straatweg" withString:@"Amsterdamsestraatweg"];
        
        [Waypoint findById:@21 managedObjectContext:self.managedObjectContext].intro = @"Aan de noordzijde van de Neude staat een standbeeld dat sterk aan het konijn uit de film Donnie Darko doet denken. Net als de huidige burgemeester is ook dit beeld tijdens een niet geheel democratisch referendum verkozen.\nLoop nu richting de flat.";
        
        [Waypoint findById:@23 managedObjectContext:self.managedObjectContext].intro = @"Volg de borden Centraal Station. Bekijk vooral het filmpje over hoe en waarom dit winkelcentrum gebouwd is \"met een op de toekomst gerichte voortvarendheid\". Hopelijk heb je genoten van de rondleiding.\nFeedback is erg welkom!";
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
  
    }
    
    if(![defaults objectForKey:@"version"] || ![[defaults objectForKey:@"version"] isEqualToArray:@[@0,@2,@1]] ) {
        [defaults setObject:@[@0,@2, @1] forKey:@"version"];
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TenSecondsAfterLaunch" object:nil userInfo:nil];

    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"logActivity"]) {
        [[Mixpanel sharedInstance] flush]; // Uploads datapoints to the Mixpanel Server.
    }

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

    // Analytics (Mixpanel)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"logActivity"]) {
        [[Mixpanel sharedInstance] track:@"launch"];
    }
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
        
        // Analytics (Mixpanel)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:@"logActivity"]) {
            [[Mixpanel sharedInstance] track:@"firstLaunch"];
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
