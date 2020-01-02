//
//  AboutViewController.m
//  Utrecht Gids
//
//  Created by Sjors Provoost on 09-03-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = nil;
    switch ([indexPath section]) {
        case 0:
            break;
        case 1:
            switch ([indexPath row]) {
                case 0:
                    url = @"http://itunes.apple.com/nl/app/domplein-tour/id441458067?mt=8";
                    break;
                case 1:
                    url = @"http://itunes.apple.com/nl/app/mijn-plek-utrecht/id408503108?mt=8";
                    break;
                case 2:
                    url = @"http://itunes.apple.com/app/lumapp/id491535409";
                    break;               
                case 3:
                    url = @"http://itunes.apple.com/app/utrecht-city-guide/id504794530";
                    break;
                default:
                    break;
            }

            break;
        case 4:
            switch ([indexPath row]) {
                case 0:
                    url = @"mailto:sjors@reisgids-utrecht.nl";
                    break;
                case 1:
                    url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=505936419";
                    break;
                default:
                    break;
            }
            
            break;
        default:
            break;
    }
    
    if(url!=nil) {    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }


    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

@end
