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
#import "AppDelegate.h"
#import "LocalizedCurrentLocation.h"
#import "Link.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

@synthesize waypoint=_waypoint;
@synthesize managedObjectContext=_managedObjectContext;

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
    
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    self.title = self.waypoint.title;
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    
    if([defaults boolForKey:@"logActivity"]) {
        NSString *title = self.waypoint.title;
        NSNumber *identifier = self.waypoint.identifier;
        
        [mixpanel track:@"info" properties:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"id", title, @"title", nil]];
        
    }
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
    if ([self.waypoint.is_sight boolValue]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 2;
    } else if(section == 1) {
        return [self.waypoint.links count];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Plattegrond";
    } else if(section == 1) {
        return @"Bron en meer info";
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *CellIdentifier;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    CellIdentifier = @"mapCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    MKMapView *map = (MKMapView *)[cell viewWithTag:1];
                    
                    map.layer.cornerRadius = 10.0;
                    
                    Waypoint *display_waypoint;
                    if([self.waypoint.is_sight boolValue]) {
                        display_waypoint = self.waypoint;
                    } else {
                        display_waypoint = [self.waypoint next:self.managedObjectContext];
                    }
                    
                    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([display_waypoint.lat floatValue], [display_waypoint.lon floatValue]);
                    

                    map.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.002, 0.002));
                    
                    
                    [map addAnnotation:[[WaypointAnnotation alloc] initWithTitle:display_waypoint.title andCoordinate:location]];  
                    
                    
                    //[map addAnnotation:[[WaypointAnnotation alloc] initWithTitle:@"You are here" andCoordinate:map.userLocation.location.coordinate]];  
                    
                    // NSLog(@"Location on map: %@", [map.userLocation.location description]);
                    
                    //    [self zoomToFitMapAnnotations:map];
                    
                    //[map removeAnnotation:[map.annotations objectAtIndex:0]];
                    
                    
                    [[NSNotificationCenter defaultCenter] addObserverForName:@"locationUpdate" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){
                        
                        map.showsUserLocation = YES;
                        
                        MKUserLocation *userLocation = map.userLocation;
                        
                        
                        if(userLocation.location!=nil && map.userLocation.location.horizontalAccuracy < 500 ) {
                            
                            if ([map.userLocation.location distanceFromLocation:display_waypoint.location] < 1500) {
                            
                                // Sometimes the iPhone thinks we're at the equator
                                WaypointAnnotation *tempAnnotation = [[WaypointAnnotation alloc] initWithTitle:@"You are here" andCoordinate:map.userLocation.location.coordinate];
                                
                                [map addAnnotation:tempAnnotation];  
                                
                                [self zoomToFitMapAnnotations:map];
                                
                                [map removeAnnotation:tempAnnotation];
                            } else {
                                // User is probably at home
                                [map setRegion:MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005)) animated:YES]; 
                                
                            }
                            
                            
                        }
                        
                    }];
                    
                    break; }
                case 1: {
                    CellIdentifier = @"routeCell";
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    break;}
                default: {
                    break;}
            }

        }
            break;
        case 1: {
            CellIdentifier = @"linkCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            NSArray *links = [self.waypoint.links sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:NO]]];
            
            cell.textLabel.text = [[links objectAtIndex:indexPath.row] valueForKey:@"title"];
            break;
        }
            
        case 2: {
            CellIdentifier = @"aboutCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            break;
        }
            
        default:
            break;
    }
     
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section ==0) {
        return 150;
    } else {
        return 43;
    }
    
}

// http://stackoverflow.com/questions/1336370/positioning-mkmapview-to-show-multiple-annotations-at-once
- (void)zoomToFitMapAnnotations:(MKMapView *)mapView { 
    if ([mapView.annotations count] < 2) return; 
    
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
    
    NSString *url;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    
    if(indexPath.section == 0 && indexPath.row == 1) {
        Waypoint *display_waypoint;
        if([self.waypoint.is_sight boolValue]) {
            display_waypoint = self.waypoint;
        } else {
            display_waypoint = [self.waypoint next:self.managedObjectContext];
        }
        
        // Detect if we have iOs 6 or later:
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            // iOs 6 or newer, use Apple maps
            
            NSDictionary *addressDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"NL", @"CountryCode",
                                         @"Utrecht", @"City",
                                         nil];
            
            CLLocationCoordinate2D location = display_waypoint.location.coordinate;
            
            MKPlacemark *destinationP = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:addressDict];
            
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationP];
            destination.name = display_waypoint.title;
            
            // Only offer walking directions if the distance is shorter than 7 kilometers, otherwise it will
            // fail with an error message. We're assuming location is reasonably up to date, because we're 
            // displaying a map already.
            
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            NSDictionary *options;

            if(locationManager.location != nil && [locationManager.location distanceFromLocation:display_waypoint.location] < 7000) {
                options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,};
            } else {
                options = nil;
            }
                
            [destination openInMapsWithLaunchOptions:options];
            
            
        } else {
            // iOs 5 or earlier: use Google Maps
            
            NSString *latlong = [NSString stringWithFormat:@"%f,%f", display_waypoint.location.coordinate.latitude, display_waypoint.location.coordinate.longitude];
            
            url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@&dirflg=w", [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[LocalizedCurrentLocation currentLocationStringForCurrentLanguage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
        
        


        
        
        if([defaults boolForKey:@"logActivity"]) {
            [mixpanel track:@"directions" properties:[NSDictionary dictionaryWithObjectsAndKeys:self.waypoint.identifier, @"id", self.waypoint.title, @"title", nil]];
        }
    } else if (indexPath.section == 1) {
        NSArray *links = [self.waypoint.links sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:NO]]];
        
        Link *link = [links objectAtIndex:indexPath.row];
        
        url = link.url;
        
        if([defaults boolForKey:@"logActivity"]) {
            [mixpanel track:@"link" properties:[NSDictionary dictionaryWithObjectsAndKeys:link.identifier, @"id", link.title, @"title", nil]];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
