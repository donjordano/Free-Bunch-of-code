//
//  RadarViewController.m
//
//  Created by Ivan Yordanov on 2/3/12.

#import "AppDelegate.h"
#import "RadarViewController.h"
#import " JSONCommunication.h"
#import "OrderDesignerTabBarViewController.h"
#import "RootViewController.h"
#import " ViewController.h"

#import "NSDictionary+JSONCategories.h"
#import " DB.h"
#import " Session.h"
#import " Order.h"

#import "MyDestination.h"

@implementation RadarViewController
@synthesize mapTypeSeg;
@synthesize showMyLocation;
@synthesize locationManager, map;

static MyDestination *destination = nil;

#pragma mark -
#pragma mark load objects

-(void)loadObjects:(CLLocationCoordinate2D)loc
{
     DB *db = [ DB sharedInstance];

    // Use the parameter not the current location
    CLLocationCoordinate2D coordinate = loc;
    
     JSONCommunication *returnJSON = [[ JSONCommunication alloc] init];
    
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:coordinate.latitude], @"lat",
                            [NSNumber numberWithDouble:coordinate.longitude], @"lng",
                            [returnJSON getDevID], @"devID",
                            [userData objectForKey:@"session_id"], @"session_id", nil];
        
    NSDictionary *result = [returnJSON getOrders:params];
    
    if (result != nil) {
        [self removeAllAnnotations];
        
        [objects removeAllObjects];
        
        NSDictionary *orders = [result objectForKey:@"orders"];
        
        NSDictionary *orderOptions;
        
        for (orderOptions in orders) {
            
            float lat = [[orderOptions objectForKey:@"lat"] floatValue];
            float lng = [[orderOptions objectForKey:@"lng"] floatValue];
            
            NSString *orderName = [NSString stringWithFormat:@"%@",[orderOptions objectForKey:@"name"]];
            NSString *orderDesc = [NSString stringWithFormat:@"%@",[orderOptions objectForKey:@"desc"]];
            float maxPrice = [[orderOptions objectForKey:@"maxprice"] floatValue];
            float minPrice = [[orderOptions objectForKey:@"minprice"] floatValue];

            NSString *orderPrice = [NSString stringWithFormat:@"%.2f EUR-%.2f EUR",minPrice,maxPrice];            
            NSString *test_id = [NSString stringWithFormat:@"%@" ,[orderOptions objectForKey:@"test_id"]];
            
            NSString *companyName = [NSString stringWithFormat:@"%@", [orderOptions objectForKey:@"company_name"]];
            NSString *cashPoint = [NSString stringWithFormat:@"%@", [orderOptions objectForKey:@"cashpoint_name"]];
            NSString *address = [NSString stringWithFormat:@"%@", [orderOptions objectForKey:@"address"]];
            
            MyPlace *place=[[MyPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat,lng)];
            
            [place setCurrentTitle:orderName];
            [place setCurrentSubTitle:[NSString stringWithFormat:@"Price: %@", [orderPrice stringByReplacingOccurrencesOfString:@"." withString:@","]]];
            [place setTest_id:test_id];
            [place setPrice:[orderPrice stringByReplacingOccurrencesOfString:@"." withString:@","]];
            [place setDesc:orderDesc];
            [place setCompanyName:companyName];
            [place setCashPoint:cashPoint];
            [place setAddress:address];
            
            [place addPlace:place];  
            
            [map addAnnotation:place];
            [objects addObject:place];
        }
    } 
}

-(void)acceptTheOrder:(NSString *)test_id withName:(NSString *)name andPrice:(NSString *)price addDesc:(NSString *)desc{
    orderTestID = test_id;
    
    [alert show];
}

- (void)acceptTheOrder:(id)object
{

    

}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
         JSONCommunication *json = [[ JSONCommunication alloc] init];
        NSDictionary *result = [json acceptOrder:orderTestID];

        if (result != NULL) {
            [self.tabBarController setSelectedIndex:1];
            //order = [ Order sharedInstance];
            //[order setOrder:result];
            //OrderDesignerTabBarViewController *ordDesigner = [[OrderDesignerTabBarViewController alloc] init];
            // load the storyboard by name
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            //ordDesigner = [storyboard instantiateViewControllerWithIdentifier:@"OrderDesignerTabBarViewController"];
            //[self presentModalViewController:ordDesigner animated:YES];
        }
    }
}
#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Radar";
    objects = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    
    map.delegate = self;
    [map setShowsUserLocation:YES];
    [map setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;  
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    region.center=coordinate;
    
    span.latitudeDelta=map.region.span.latitudeDelta /12000.0002;
    span.longitudeDelta=map.region.span.longitudeDelta /12000.0002;
    region.span=span;
    [map setRegion:region animated:TRUE];
    totalDistance = 0.0;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Radar";

    [self loadObjects:self.map.centerCoordinate];
}

- (void)viewDidUnload{
    //[locationManager stopUpdatingLocation];
    
    [self setShowMyLocation:nil];
    [self setMapTypeSeg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    if(newLocation != nil && oldLocation != newLocation)
    {
        tempNewLocation = newLocation;
        tempOldLocation = oldLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	
}

#pragma mark -
#pragma mark MyLocation
-(IBAction)myLocation:(id)sender{
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [map setCenterCoordinate:coordinate animated:YES];
    
    if (destination)
    {
        [self.map removeAnnotation:destination];
        destination = nil;
    }
    
    // refresh the objects after we moved to the current location
    [self loadObjects:coordinate];
}

- (IBAction)reloadObjects:(id)sender {
    // Refresh with the center coordinate of the current map
    
    if (destination)
    {
        [self.map setCenterCoordinate:destination.coordinate];
    }
    else 
    {
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];

        [self.map setCenterCoordinate:coordinate];
    }
    
    [self loadObjects:self.map.centerCoordinate];
}

- (IBAction)logOut:(id)sender {
     DB *db = [ DB sharedInstance];
    [db deleteUserFromDB];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs integerForKey:@"kGoToLogin"] == 1){
        
        [prefs setInteger:1 forKey:@"kGoToLogin"];
        [prefs setInteger:0 forKey:@"kGoToRadar"];

        [prefs synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginV = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        [self.navigationController presentModalViewController:loginV animated:NO];
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)changeMapType:(id)sender {
    if (mapTypeSeg.selectedSegmentIndex == 0) {
        map.mapType = MKMapTypeSatellite;
        
    }
    if (mapTypeSeg.selectedSegmentIndex == 1) {
        map.mapType = MKMapTypeStandard;
        
    }
}
@end
