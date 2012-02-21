//
//  DataViewController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waypoint.h"

@interface WaypointViewController : UIViewController {
    
    IBOutlet UILabel *waypointTitle;
    IBOutlet UILabel *intro;
    IBOutlet UIImageView *picture;
    
    IBOutlet UIPageControl *pageControl;
}


@property (strong, nonatomic) Waypoint *waypoint;
@property (nonatomic) int currentPage;
@property (nonatomic) int numberOfPages;

@end
