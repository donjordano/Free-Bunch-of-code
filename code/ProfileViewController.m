//
//  ProfileViewController.m
//   
//
//  Created by Ivan Yordanov on 2/25/12.

#import "ProfileViewController.h"
#import " JSONCommunication.h"
#import " Session.h"
#import " DB.h"
#import "DatePickerViewController.h"
#import "NSDictionary+JSONCategories.h"


@implementation ProfileViewController
@synthesize fullName;
@synthesize tView;
@synthesize sexSegment;
@synthesize bankAccount;
@synthesize getMoneyBtn;
@synthesize editBtn;

UIDatePicker *datePicker;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    isEditMode = NO;
}

- (void)viewDidUnload
{
    [self setEditBtn:nil];
    [self setGetMoneyBtn:nil];
    [self setSexSegment:nil];
    [self setTView:nil];
    [self setFullName:nil];
    [self setBankAccount:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setEditMode:nil];
    [self reloadUserData];
}

-(void)reloadUserData
{
    //session = [ Session sharedInstance];
    
     Session *session = [ Session sharedInstance];
    
    json = [[ JSONCommunication alloc] init];
     DB *db = [ DB sharedInstance];

    NSDictionary *result = [json getSession:session.mail andPass:session.pass];
    
    // If there is no internet connection result might be nil
    if (result)
    {
        [session setSession_id:[result objectForKey:@"session_id"]];
        NSString *user_data_string = [result toStringFromJSON];
        
        [db addUserToDB:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"id", user_data_string, @"user_data",nil]];
    }

    // If there is no internet connection get the data from db - might not be correct though
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    
    userData = [NSDictionary dictionaryWithString:user_data_str];
    
    if ([session.birthdate isEqualToString:@""] || session.birthdate == nil) {
        [session setBirthdate:[userData objectForKey:@"birthdate"]];
    }
    
    [session setIban:[userData objectForKey:@"bank_account"]];
    [session setFullname:[userData objectForKey:@"username"]];
    [session setBalance:[userData objectForKey:@"balance"]];
    [session setSex:[userData objectForKey:@"sex"]];
    
    fullName.text = session.fullname;
    [fullName setReturnKeyType:UIReturnKeyDone];
    [fullName addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    bankAccount.text = session.iban;
    [bankAccount setReturnKeyType:UIReturnKeyDone];
    [bankAccount addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)loadView
{
    isEditMode = NO;
    tView.userInteractionEnabled = NO;
    [super loadView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        return 5;
    }
        
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (isEditMode) {
        cell.userInteractionEnabled = YES;
    } else {
        cell.userInteractionEnabled = NO;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Mail: %@", [userData objectForKey:@"email"]];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Change Password";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name: ";
            [cell addSubview:fullName];
        }
        
        if (indexPath.row == 1) {
             Session *session = [ Session sharedInstance];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:session.birthdate];
            
            NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd-MM-yyyy" options:0
                                                                      locale:[NSLocale currentLocale]];
            [dateFormat setDateFormat:formatString];
            NSString *dateString = [dateFormat stringFromDate:date];
            cell.textLabel.text = [NSString stringWithFormat:@"Birthdate: %@", dateString];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Sex: ";
            
            if ([[userData objectForKey:@"sex"] intValue] == 1) {
                sexSegment.selectedSegmentIndex = 1;
            } 
            if ([[userData objectForKey:@"sex"] intValue] == 2) {
                sexSegment.selectedSegmentIndex = 0;
            }
            
            [cell addSubview:sexSegment];
        }
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"IBAN: ";
            [cell addSubview:bankAccount];
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = [NSString stringWithFormat:@"Balance: %.2f EUR", [[userData objectForKey:@"balance"] floatValue]];
            
            NSString *balnce = [NSString stringWithFormat:@"%.2f", [[userData objectForKey:@"balance"] floatValue]];
            
            if (![balnce isEqualToString:@"0.00"])
            {        
                getMoneyBtn.hidden = NO;
                cell.userInteractionEnabled = YES;
                [cell addSubview:getMoneyBtn];
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"chPass" sender:self];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
//        DatePickerViewController *datePick = [[DatePickerViewController alloc] init];
//        
//        // load the storyboard by name
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//        datePick = [storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
//        [self presentModalViewController:datePick animated:YES];
        
        [self showDatePicker];
    }
    
    NSArray *fileds = [NSArray arrayWithObjects:fullName, bankAccount, nil];
    for (id field in fileds) {
        if ([field isFirstResponder]){
            [field resignFirstResponder];
        }
    }
}

-(void)showDatePicker{
    aac = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                      delegate:self
                             cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                             otherButtonTitles:nil];
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    
    [theDatePicker addTarget:self action:@selector(changeDateInLabel) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick:)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    
    [aac addSubview:pickerDateToolbar];
    [aac addSubview:theDatePicker];
    [aac showInView:self.view];
    [aac setBounds:CGRectMake(0,0,320, 464)];

}

- (void)DatePickerDoneClick:(id)sender{
    [aac dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)setEditMode:(id)sender 
{
    if (!isEditMode) {
        UIImage *saveImg = [UIImage imageNamed:@"UIBarButtonOrganize.png"];
        self.navigationItem.rightBarButtonItem.image = saveImg;
        isEditMode = YES;
        self.navigationItem.title = @"Edit Profile";
        [self.tableView reloadData];
    }
    else{
        UIImage *doneImg = [UIImage imageNamed:@"UIBarButtonCompose.png"];
        self.navigationItem.rightBarButtonItem.image = doneImg;
        isEditMode = NO;
        
         Session *session = [ Session sharedInstance];
        
        self.navigationItem.title = @"My Profile";
        
        if (sexSegment.selectedSegmentIndex == 0) {
            session = [ Session sharedInstance];
            session.sex = [NSNumber numberWithInt:2];
        }
        
        if (sexSegment.selectedSegmentIndex == 1) {
            session = [ Session sharedInstance];
            session.sex = [NSNumber numberWithInt:1];
        }
        
        session = [ Session sharedInstance];
        session.iban = bankAccount.text;
        session.fullname = fullName.text;
        [json updateProfile];
        
        [self reloadUserData];
    }
}

- (IBAction)getTheMoney:(id)sender 
{
    NSDictionary *dict = [json requestPayment];
    if ([[dict objectForKey:@"success"] intValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Request for money transfer successuflly!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        getMoneyBtn.hidden = YES;
        [self reloadUserData];
    }
}


#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self reloadUserData];
    [self.tableView reloadData];
}

- (void)changeDateInLabel
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormat stringFromDate:theDatePicker.date];
     Session *session = [ Session sharedInstance];
    [session setBirthdate:stringDate];
//    NSDate *date = [dateFormat dateFromString:session.birthdate];
//    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd-MM-yyyy" options:0
//                                                              locale:[NSLocale currentLocale]];
//    [dateFormat setDateFormat:formatString];
//    NSString *dateString = [dateFormat stringFromDate:date];
    [self.tableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *fileds = [NSArray arrayWithObjects:fullName, bankAccount, nil];
    UITouch *touch = [[event allTouches] anyObject];
    for (id field in fileds) {
        if ([field isFirstResponder] && [touch view] != field && [touch view] == self.tableView){
            [field resignFirstResponder];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

@end
