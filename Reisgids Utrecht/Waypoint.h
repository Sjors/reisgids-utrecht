//
//  Waypoint.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 20-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface Waypoint : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * range;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * picture_name;
@property (nonatomic, retain) NSNumber * is_sight;

+(Waypoint *)findByPosition:(NSNumber *)position managedObjectContext:(NSManagedObjectContext *)moc;

-(CLLocation *)location;

-(Waypoint *)next:(NSManagedObjectContext *)moc;

@end
