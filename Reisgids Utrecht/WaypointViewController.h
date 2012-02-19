//
//  DataViewController.h
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaypointViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *waypointTitle;
@property (strong, nonatomic) IBOutlet UILabel *intro;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) id dataObject;
@end
