//
//  DataViewController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waypoint.h"
#import "TTTAttributedLabel.h"


@interface WaypointViewController : UIViewController <TTTAttributedLabelDelegate> {
    
    IBOutlet UILabel *waypointTitle;
//    IBOutlet TTTAttributedLabel *intro;
    IBOutlet UIView *intro;

    IBOutlet UIImageView *picture;
    
    IBOutlet UIButton *infoButton;
    
    IBOutlet UIPageControl *pageControl;
    
    IBOutlet UIView *explanationView;
}


@property (strong, nonatomic) Waypoint *waypoint;
@property (nonatomic) int currentPage;
@property (nonatomic) int numberOfPages;

@end
