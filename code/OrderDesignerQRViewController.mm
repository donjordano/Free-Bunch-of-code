//
//  OrderDesignerQRViewController.m
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderDesignerQRViewController.h"
#import "QRCodeReader.h"

@implementation OrderDesignerQRViewController

@synthesize resultsToDisplay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    //ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    //QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    //NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    //widController.readers = readers;
    //NSBundle *mainBundle = [NSBundle mainBundle];
    //[self.view addSubview:widController.view];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    resultsToDisplay = result;
    if (self.isViewLoaded) {
        //[resultsView setText:resultsToDisplay];
        //[resultsView setNeedsDisplay];
    }
    //[self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    //[self dismissModalViewControllerAnimated:YES];
}

@end
