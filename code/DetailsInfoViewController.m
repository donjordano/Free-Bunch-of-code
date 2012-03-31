//
//  DetailsInfoViewController.m
//   
//
//  Created by Ivan Yordanov on 2/5/12.

#import "DetailsInfoViewController.h"

@implementation DetailsInfoViewController


-(id)initWithInfo:(NSString *)fName{
    self = [super init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView* web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    web.backgroundColor = [UIColor clearColor];
    //load a local file
    NSError* error = nil;
    NSString* fileContents = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fName] encoding:NSUTF8StringEncoding error: &error];
    if (error!=NULL) {
        NSLog(@"error loading %@: %@", fName, [error localizedDescription]);
    } else {
        [web loadHTMLString: fileContents baseURL:[NSURL URLWithString:@"file://"]];
    }
    [self.view addSubview:web];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
