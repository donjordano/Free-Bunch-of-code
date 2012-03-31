//
//  OrderViewController.m
//   
//
//  Created by Ivan Yordanov on 2/25/12.

#import "OrderViewController.h"
#import " JSONCommunication.h"
#import "OrderDesignerTabBarViewController.h"

#import " DB.h"
#import " Order.h"
#import " Session.h"

#import "NSDictionary+JSONCategories.h"

@interface OrderViewController (Private)
- (NSInteger)getFinishedTests;
@end


@implementation OrderViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     DB *db = [ DB sharedInstance];
     Session *session = [ Session sharedInstance];
     JSONCommunication *json = [[ JSONCommunication alloc] init];
    
    NSDictionary *result = [json getSession:session.mail andPass:session.pass];
 
    // If there is no internet connection result might be nil
    if (result)
    {
        [session setSession_id:[result objectForKey:@"session_id"]];
        NSString *user_data_string = [result toStringFromJSON];
        
        [db addUserToDB:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"id", user_data_string, @"user_data",nil]];
        NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
        
        NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
        
        activeOrders  = (NSArray *)[userData objectForKey:@"activeOrders"];
        finishedOrders = (NSArray *)[userData objectForKey:@"finished"];
        
        [self.tableView reloadData];
    }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret;
    
    if (section == 0){
        if ([activeOrders count] == 0)
            ret =  1;
        else
            ret =  [activeOrders count];
    } 
    if (section ==1) {        
        if ([self getFinishedTests] == 0)
            ret = 1;
        else
            ret = [self getFinishedTests];
    } 
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if ([activeOrders count] == 0) {
            cell.textLabel.text = @"No active tests";
            cell.detailTextLabel.text = @"";
        } else {
            // Get the order only if there are active orders. otherwise the app crashes...
            NSDictionary *aOrder = [[activeOrders objectAtIndex:indexPath.row] objectForKey:@"order"];

            cell.textLabel.text = [aOrder objectForKey:@"name"];
            cell.detailTextLabel.text = [aOrder objectForKey:@"desc"];
        }
    }
    
    if (indexPath.section == 1) {
        // Use getFinishedTests not finishedOrders, which contains canceled as well
        if ([self getFinishedTests] == 0) {
            cell.textLabel.text = @"No finished tests";
            cell.detailTextLabel.text = @"";
        } else {
            NSString *fCanceled = [[finishedOrders objectAtIndex:indexPath.row] objectForKey:@"canceled"];
            
            // If this is not canceled order show it as finished
            if ([fCanceled isEqualToString:@"0"])
            {
                NSString *fOrder = [[finishedOrders objectAtIndex:indexPath.row] objectForKey:@"name"];
                cell.textLabel.text = fOrder;
            }
        } 
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         Order *order = [ Order sharedInstance];
        
        // Don't try to select when there are no orders
        if ([activeOrders count] != 0)
        {
            [order setOrder:[activeOrders objectAtIndex:indexPath.row]];
            
            OrderDesignerTabBarViewController *ordDesigner = [[OrderDesignerTabBarViewController alloc] init];
            
            // load the storyboard by name
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            ordDesigner = [storyboard instantiateViewControllerWithIdentifier:@"OrderDesignerTabBarViewController"];
            [self presentModalViewController:ordDesigner animated:YES];
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) 
        return @"Active tests";
    else
        return @"Finished tests";
}


- (NSInteger)getFinishedTests
{
    // not canceled tests are finished
    NSInteger notCanceled = 0;
    
    for (NSDictionary *fCanceled in finishedOrders) 
    {
        NSString *cancel = [fCanceled objectForKey:@"canceled"];
        // If this is not canceled order show it as finished
        if ([cancel isEqualToString:@"0"])
        {
            notCanceled++;
        }
    }

    return notCanceled;
}


@end
