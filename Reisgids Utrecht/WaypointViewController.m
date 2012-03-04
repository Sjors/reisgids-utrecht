//
//  DataViewController.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "WaypointViewController.h"
#import "InfoTableViewController.h"

@implementation WaypointViewController

@synthesize waypoint=_waypoint;
@synthesize currentPage=_currentPage;
@synthesize numberOfPages=_numberOfPages;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    waypointTitle.text = self.waypoint.title;
    waypointTitle.accessibilityLabel = self.waypoint.title;

    intro.text = self.waypoint.intro;
    
    // Top align text
    CGSize maximumSize = CGSizeMake(280, 165);
    CGSize stringSize = [self.waypoint.intro sizeWithFont:[UIFont systemFontOfSize:17.0] 
                                   constrainedToSize:maximumSize 
                                       lineBreakMode:intro.lineBreakMode];
    
    CGRect frame = CGRectMake(20, 61, 280, stringSize.height);
    
    intro.frame = frame;
    
    picture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.waypoint.picture_name]];
    
    pageControl.currentPage = self.currentPage;
    pageControl.numberOfPages = self.numberOfPages;
    
    infoButton.hidden = ![self.waypoint.is_sight boolValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];//    self.dataLabel.text = [self.dataObject description];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"info"]  ) {
        InfoTableViewController *vc = (InfoTableViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        vc.waypoint = self.waypoint;
    }
}



@end
