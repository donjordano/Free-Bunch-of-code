//
//  RadarViewController.m
//  C4F
//
//  Created by Ivan Yordanov on 2/3/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "AppDelegate.h"
#import "RadarViewController.h"
#import "C4FJSONCommunication.h"
#import "OrderDesignerTabBarViewController.h"
#import "RootViewController.h"
#import "C4FViewController.h"

#import "NSDictionary+JSONCategories.h"
#import "C4FDB.h"
#import "C4FSession.h"
#import "C4FOrder.h"

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
    C4FDB *db = [C4FDB sharedInstance];

    // Use the parameter not the current location
    CLLocationCoordinate2D coordinate = loc;
    
    C4FJSONCommunication *returnJSON = [[C4FJSONCommunication alloc] init];
    
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
            
            // Must be fixed and made faster and with low memory consumpion, but not now
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
    
    // Show Test name
    //      Company name
    //      Cash point
    //      Short description
    //      Address
    //      Price
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name 
                                                    message:[NSString stringWithFormat:@"Price:%@\n Description: \n %@ \n Do you accept this order?", price, desc]
                                                    delegate:self 
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)acceptTheOrder:(id)object
{
//    MyPlace *obj = [objects objectAtIndex:selectedIndex];
//    
//    [self acceptTheOrder:[obj test_id] withName:[obj title] andPrice:[obj price] addDesc:[obj desc]];
    MyPlace *obj = (MyPlace *)object;
    orderTestID = [obj test_id];
    
    NSString *title = [NSString stringWithFormat:@"Name: %@", obj.currentTitle];
    NSString *subtitle = [NSString stringWithFormat:@"Company Name: %@\n Cash point: %@\n Short Description: \n %@ \n Address: %@ \n %@\n Do you accept this order?", obj.companyName, obj.cashPoint, obj.desc, obj.address, obj.price];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:subtitle
                                                   delegate:self 
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
    

}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        C4FJSONCommunication *json = [[C4FJSONCommunication alloc] init];
        NSDictionary *result = [json acceptOrder:orderTestID];

        if (result != NULL) {
            [self.tabBarController setSelectedIndex:1];
            //order = [C4FOrder sharedInstance];
            //[order setOrder:result];
            //OrderDesignerTabBarViewController *ordDesigner = [[OrderDesignerTabBarViewController alloc] init];
            // load the storyboard by name
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            //ordDesigner = [storyboard instantiateViewControllerWithIdentifier:@"OrderDesignerTabBarViewController"];
            //[self presentModalViewController:ordDesigner animated:YES];
        }
    }
}

#pragma mark - Long press gesture
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    MyDestination *dest = [[MyDestination alloc] initWithCoordinate:touchMapCoordinate];

    // Remove the old destination pin
    if (destination) {
        [self.map removeAnnotation:destination];
    }
    
    destination = dest;
    
    [self.map addAnnotation:destination];
    
    [self loadObjects:touchMapCoordinate];
}

- (void)removeAllAnnotations
{
    for (id annotation in self.map.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]] &&
            ![annotation isKindOfClass:[MyDestination class]]
            ) {
            [self.map removeAnnotation:annotation];
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

    // Add long press gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPress setMinimumPressDuration:1.0]; 
    
    [map addGestureRecognizer:longPress];
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

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    // Draw MyDestination pin
    else if([annotation isKindOfClass:[MyDestination class]])
    {
        static NSString *DestinationIdentifier = @"DestinationIdentifier";

        MKPinAnnotationView *destinationPin = (MKPinAnnotationView*)[mV dequeueReusableAnnotationViewWithIdentifier:DestinationIdentifier];

        if (destinationPin == nil) {
            destinationPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:DestinationIdentifier];
            
            destinationPin.pinColor = MKPinAnnotationColorPurple;
            destinationPin.animatesDrop = YES;
            destinationPin.canShowCallout = NO;
        }
        
        return destinationPin;
    }
    
	else{
        
        UIImage *acceptImage = [UIImage imageNamed:@"Accept.png"];
        
        UIButton *acceptOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptOrder setFrame:CGRectMake(0, 0, acceptImage.size.width, acceptImage.size.height)];
        [acceptOrder setImage:acceptImage forState:UIControlStateNormal];
        //[acceptOrder addTarget:self action:@selector(acceptTheOrder:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger annotationValue = [objects indexOfObject:annotation];
        acceptOrder.tag = annotationValue;
        
        MKAnnotationView *annotationView = nil;        
        static NSString *StartPinIdentifier = @"PinIdentifier";
        
        // NOTE: Do not dequeue so that the pins and annotations correctly reloaded
        // REMOVE THIS CODE WE PROVEN CORRECT
//        MKPinAnnotationView *startPin = (id)[mV dequeueReusableAnnotationViewWithIdentifier:StartPinIdentifier];
//		if (startPin == nil) {
            MKPinAnnotationView *startPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StartPinIdentifier];
            startPin.animatesDrop = NO;
            startPin.rightCalloutAccessoryView = acceptOrder;           
            startPin.canShowCallout = YES;
            startPin.enabled = YES;
//        }
        annotationView = startPin;
        return annotationView;
	}   
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSInteger selectedIndex = control.tag;
    
    if ([[objects objectAtIndex:selectedIndex] isKindOfClass:[MyPlace class]]) {
        MyPlace *obj = [objects objectAtIndex:selectedIndex];
        
        // Use the new acceptTheOrder instead
        // [self acceptTheOrder:[obj test_id] withName:[obj title] andPrice:[obj price] addDesc:[obj desc]];
        
        [self acceptTheOrder:obj];
    }
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
    C4FDB *db = [C4FDB sharedInstance];
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
