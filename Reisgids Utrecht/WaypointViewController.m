//
//  DataViewController.m
//  Reisgids Utrecht
//
//  Created by Sjors Provoost on 19-02-12.
//  Copyright (c) 2012 Sjors Provoost. All rights reserved.
//

#import "WaypointViewController.h"
#import "InfoTableViewController.h"
#import "Link.h"
#import "AppDelegate.h"

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

    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        waypointTitle.text = self.waypoint.title;
    } else {
        NSDictionary *attributes = @{
            NSKernAttributeName : [NSNull null]
        };


        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc]initWithString:self.waypoint.title attributes:attributes];

        waypointTitle.attributedText = titleText;
    }

    waypointTitle.accessibilityLabel = self.waypoint.title;


    // Top align text
//    CGSize maximumSize = CGSizeMake(280, 165);
//    CGSize stringSize = [self.waypoint.intro sizeWithFont:[UIFont systemFontOfSize:17.0]
//                                   constrainedToSize:maximumSize
//                                       lineBreakMode:intro.lineBreakMode];
//
//    CGRect frame = CGRectMake(20, 61, 280, stringSize.height); // 61
//
//    intro.frame = frame;


    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        // Use TTTAttributedString in iOs 5


        TTTAttributedLabel *introView = (TTTAttributedLabel *)intro;


        introView.delegate = self;

        introView.lineBreakMode = UILineBreakModeWordWrap;
        introView.numberOfLines = 10;

        introView.text = self.waypoint.intro;

        introView.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;

        for (Link *link in self.waypoint.links) {
            if (link.match != nil) {
                NSRange range = [introView.text rangeOfString:link.match];
                [introView addLinkToURL:[NSURL URLWithString:link.url] withRange:range];
            }
        }
    } else {
        // Use native attributed string in iOs 6

        UILabel *introView = [[UILabel alloc] init];
        introView.frame = intro.frame;
        introView.lineBreakMode = UILineBreakModeWordWrap;;
        introView.numberOfLines = 10;
        // introView.textAlignment = NSTextAlignmentJustified;

        UIView *superView = intro.superview;

        [intro removeFromSuperview];
        [superView addSubview:introView];

        // introView.text = self.waypoint.intro;

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.hyphenationFactor = 0.90;
        style.alignment = NSTextAlignmentLeft;

        NSDictionary *attributes = @{NSParagraphStyleAttributeName : style,
        NSKernAttributeName : [NSNull null],
        NSFontAttributeName : introView.font
        };

        NSMutableAttributedString *introText = [[NSMutableAttributedString alloc]initWithString:self.waypoint.intro attributes:attributes];

        // Process links:
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES];
        NSArray *sortedLinks = [[self.waypoint.links allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

        int tagCount = 0;

        for(Link *link in sortedLinks) {
            if (link.match != nil) {
                // Mark the link:
                NSRange range = [self.waypoint.intro rangeOfString:link.match];
                [introText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
                [introText addAttribute:NSUnderlineStyleAttributeName  value:@1 range:range];

                // Figure out where the link appears:

                // Starting position:
                NSAttributedString *startAS = [[NSMutableAttributedString alloc]initWithString:[self.waypoint.intro substringToIndex:range.location] attributes:attributes];

                CGRect before = [startAS boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];

                // Size of the link (assuming it's on a single line)
                NSAttributedString *onlyURL = [[NSMutableAttributedString alloc]initWithString:link.match attributes:attributes];


                // Find the text left of the word:
                BOOL found = NO;
                int charactersBefore = -1;
                while (!found) {
                    charactersBefore++;

                    // Strip a few characters off the text before the link
                    NSAttributedString *beforeShorter = [[NSMutableAttributedString alloc]initWithString:[self.waypoint.intro substringToIndex:range.location - charactersBefore] attributes:attributes];

                    CGRect beforeS = [beforeShorter boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];

                    found = beforeS.size.height < before.size.height - 5;
                }

                charactersBefore--;

                // Word wrapping could cause a short word to be moved to the line above,
                // so we need to find the start of the current word.

                NSRange startOfLineEnter = [self.waypoint.intro rangeOfString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0, range.location - charactersBefore)];

                int startOfLine;
                if(startOfLineEnter.location != NSNotFound) {
                    startOfLine = startOfLineEnter.location + 1;
                } else {
                    startOfLine = [self.waypoint.intro rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, range.location - charactersBefore)].location + 1;
                }

                // The text on the same line, but before the link:
                NSAttributedString *lineStart = [[NSMutableAttributedString alloc]initWithString:[self.waypoint.intro substringWithRange:NSMakeRange(startOfLine, range.location - startOfLine)] attributes:attributes];

                CGRect lineStartR = [lineStart boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];


                // Is the link located at the start of the line (or part of a line break)?
                NSAttributedString *endAS = [[NSMutableAttributedString alloc]initWithString:[self.waypoint.intro substringToIndex:range.location + range.length] attributes:attributes];
                CGRect after = [endAS boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];

                UIButton *overlay = [UIButton buttonWithType:UIButtonTypeCustom];

                if(after.size.height != before.size.height) {
                    // Check for linebreak, using one or more words from the
                    // link (make sure no links hyphenated)
                    // Too complicated: for now just avoid multi-word links near the end of a line.
                    BOOL linebreak = NO;
//                    if (<#condition#>) {
//                        <#statements#>
//                    }
//
                    if(linebreak) { // Linebreak:

                    } else { // Start of line:
                        overlay.frame = CGRectMake(0, before.size.height, onlyURL.size.width, onlyURL.size.height);
                    }
                } else {
                     overlay.frame = CGRectMake(lineStartR.size.width, before.size.height - onlyURL.size.height, onlyURL.size.width, onlyURL.size.height);
                }


                // Create a button:
//                CGRect rect = [introText boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];


                // overlay.backgroundColor = [UIColor redColor];
                overlay.alpha = 0.1;
                overlay.tag = tagCount;
                introView.userInteractionEnabled = YES;

                [overlay addTarget:self action:@selector(didTapUrl:) forControlEvents:UIControlEventTouchUpInside];


                [introView addSubview:overlay];
            }

            tagCount++;

        }








//        for (Link *link in self.waypoint.links) {
//            if (link.match != nil) {
//                NSRange range = [introView.text rangeOfString:link.match];
//                [introText addAttribute:NSFontAttributeName value:<#(id)#> range:<#(NSRange)#>] // NSLinkAttributeName
//
//                 // addLinkToURL:[NSURL URLWithString:link.url] withRange:range];
//            }
//        }

        introView.attributedText = introText;

        [introView sizeToFit];

    }

    picture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.waypoint.identifier]];

    pageControl.currentPage = self.currentPage / 3;
    pageControl.numberOfPages = self.numberOfPages / 3;

    // Monitor when to show "More information sticky"
    [[NSNotificationCenter defaultCenter] addObserverForName:@"TenSecondsAfterLaunch" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif){

        explanationView.hidden = NO;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
            explanationView.hidden = YES;


        });
    }] ;


}

// iOs 5:
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

// iOs 6:
-(IBAction)didTapUrl:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES];
    NSArray *sortedLinks = [[self.waypoint.links allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];

    Link *link = [sortedLinks objectAtIndex:sender.tag];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link.url]];
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
    if ([[segue identifier] isEqualToString:@"info"] || [[segue identifier] isEqualToString:@"infoFromExplanationView"] || [[segue identifier] isEqualToString:@"infoLargerArea"] ) {
        InfoTableViewController *vc = (InfoTableViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        vc.waypoint = self.waypoint;
    }
}



@end
