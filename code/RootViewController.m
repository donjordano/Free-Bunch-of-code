//
//  RootViewController.m
//  C4F
//
//  Created by Ivan Yordanov on 2/12/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
   NSString *video_ID = @"";
    
    NSString *htmlStr = [NSString stringWithFormat:@"<iframe class=\"youtube-player\" type=\"text/html\" width=\"320\" height=\"480\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"></iframe>",video_ID];
    
    [web loadHTMLString:htmlStr baseURL:nil];
     */

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWeb:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToLogin:(id)sender {
    [self performSegueWithIdentifier:@"loginView" sender:sender];
}
@end
