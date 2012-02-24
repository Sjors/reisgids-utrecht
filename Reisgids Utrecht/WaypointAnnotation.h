//
//  WaypointAnnotation.h
//  Utrecht Gids
//
//  Created by Sjors Provoost on 24-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WaypointAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end
