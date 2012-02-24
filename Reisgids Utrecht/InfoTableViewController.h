//
//  InfoTableViewController.h
//  Utrecht Gids
//
//  Created by Sjors Provoost on 24-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "Waypoint.h"

@interface InfoTableViewController : UITableViewController {
    
}

@property (nonatomic, strong) Waypoint *waypoint;

@end
