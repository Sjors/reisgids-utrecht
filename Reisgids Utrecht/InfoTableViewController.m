//
//  InfoTableViewController.m
//  Utrecht Gids
//
//  Created by Sjors Provoost on 24-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "InfoTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WaypointAnnotation.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

@synthesize waypoint=_waypoint;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.waypoint.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoScreen" object:nil userInfo:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTurned" object:nil userInfo:[NSDictionary dictionaryWithObject:self.waypoint.position forKey:@"waypoint_pos"]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"locationUpdate"];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MKMapView *map = (MKMapView *)[cell viewWithTag:1];
    
    map.layer.cornerRadius = 10.0;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.waypoint.lat floatValue], [self.waypoint.lon floatValue]);
    
    //map.region = MKCoordinateRegionMakeWithDistance(map.userLocation.location.coordinate, 70, 70);
    map.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.002, 0.002));
        

    [map addAnnotation:[[WaypointAnnotation alloc] initWithTitle:self.waypoint.title andCoordinate:location]];  
    
    
    //[map addAnnotation:[[WaypointAnnotation alloc] initWithTitle:@"You are here" andCoordinate:map.userLocation.location.coordinate]];  
    
    // NSLog(@"Location on map: %@", [map.userLocation.location description]);
    
//    [self zoomToFitMapAnnotations:map];
    
    //[map removeAnnotation:[map.annotations objectAtIndex:0]];

    
//   [[NSNotificationCenter defaultCenter] addObserverForName:@"locationUpdate" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
//       
//        [map addAnnotation:[[WaypointAnnotation alloc] initWithTitle:@"You are here" andCoordinate:map.userLocation.location.coordinate]];  
//       
//       [self zoomToFitMapAnnotations:map];
//
//   }];
    
    return cell;
}

// http://stackoverflow.com/questions/1336370/positioning-mkmapview-to-show-multiple-annotations-at-once
- (void)zoomToFitMapAnnotations:(MKMapView *)mapView { 
    if ([mapView.annotations count] == 0) return; 
    
    CLLocationCoordinate2D topLeftCoord; 
    topLeftCoord.latitude = -90; 
    topLeftCoord.longitude = 180; 
    
    CLLocationCoordinate2D bottomRightCoord; 
    bottomRightCoord.latitude = 90; 
    bottomRightCoord.longitude = -180; 
    
    
    
    for(WaypointAnnotation *annotation in mapView.annotations) { 
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
    } 
    
    MKCoordinateRegion region; 
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
    
    // Add a little extra space on the sides 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; 
    
    // Add a little extra space on the sides 
    region = [mapView regionThatFits:region]; 
    [mapView setRegion:region animated:YES]; 
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
