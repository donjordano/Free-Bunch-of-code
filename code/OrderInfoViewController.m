//
//  OrderInfoViewController.m
//   
//
//  Created by Ivan Yordanov on 2/28/12.

#import "OrderInfoViewController.h"
#import " DB.h"
#import " Session.h"
#import " JSONCommunication.h"
#import " Order.h"


@implementation OrderInfoViewController
@synthesize cancelTestBtn = _cancelTestBtn;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

     Order *order = [ Order sharedInstance];
    orderInfo = order.order;
    [order setReference_id:[[orderInfo objectForKey:@"order"] objectForKey:@"reference_id"]];
}

- (void)viewDidUnload
{
    [self setCancelTestBtn:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 5, 250, 20);
        label.text = [NSString stringWithFormat:@"Contact name:%@", [[orderInfo objectForKey:@"order"] objectForKey:@"contact_name"]];
        [cell addSubview:label];
        
        NSURL *url = [NSURL URLWithString:[[orderInfo objectForKey:@"order"] objectForKey:@"contact_picture"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        UIImageView *contactImage = [[UIImageView alloc] initWithImage:img];
        contactImage.frame = CGRectMake(15, 25, 290, 150);
        [cell addSubview:contactImage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
    if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"Contact phone:%@", [[orderInfo objectForKey:@"order"] objectForKey:@"contact_phone"]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"Contact mail:%@", [[orderInfo objectForKey:@"order"] objectForKey:@"contact_email"]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } 
    
    if (indexPath.row == 3) {
        [cell addSubview:_cancelTestBtn];
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 185.0f;
    else return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //call to contact number
        NSString *tel = [NSString stringWithFormat:@"tel:%@", [[orderInfo objectForKey:@"order"] objectForKey:@"contact_phone"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
    if (indexPath.row == 2) {
        [self writeMailToContact];
    }
}

#pragma mark - 
#pragma mark Mail Composer
- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)writeMailToContact{
	if ([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
		
        mailer.mailComposeDelegate = self;
		
        //about order...
        [mailer setSubject:@"Order"];
		//mail from order
        NSArray *toRecipients = [NSArray arrayWithObjects:[[orderInfo objectForKey:@"order"] objectForKey:@"contact_email"], nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody = @" ";
        [mailer setMessageBody:emailBody isHTML:NO];
		
        [self presentModalViewController:mailer animated:YES];
		
    }
	else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//mail composer delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
	
	// Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelOrder:(id)sender {
     JSONCommunication *json = [[ JSONCommunication alloc] init];
     Order *order = [ Order sharedInstance];
    [json cancelTest:order.reference_id];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)completeOrder:(id)sender {
}
@end
