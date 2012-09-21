//
//  Link.h
//  Utrecht Gids
//
//  Created by Sjors Provoost on 07-03-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Waypoint;

@interface Link : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * match;
@property (nonatomic, retain) Waypoint *waypoint;

+(Link *)findById:(NSNumber *)identifier managedObjectContext:(NSManagedObjectContext *)moc;
+(Link *)findByUrl:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)moc;


@end
