//
//  RadarViewController.h
//  Created by Ivan Yordanov on 2/3/12.
//This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
//http://creativecommons.org/licenses/by-nc-sa/3.0/
//CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE LEGAL SERVICES. 
//DISTRIBUTION OF THIS LICENSE DOES NOT CREATE AN ATTORNEY-CLIENT RELATIONSHIP. 
//CREATIVE COMMONS PROVIDES THIS INFORMATION ON AN "AS-IS" BASIS. 
//CREATIVE COMMONS MAKES NO WARRANTIES REGARDING THE INFORMATION PROVIDED, 
//AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM ITS USE. 
//THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
// ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW.
//ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
//Copyright (c) Ivan Yordanov 2012

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyPlace.h"

@interface RadarViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>{
    
   // Core Location Manager for managing location updates
    CLLocationManager *locationManager;
    
    // Map View for displaying results to a map
    IBOutlet MKMapView *map;
    
    // An array of way points where pins would be dropped on the map
    NSMutableArray *wayPoints;
    
    // Timer elements for timing location updates
    NSTimer *stopTimer;
    NSDate *stopTime;
    NSDate *startTime;
    
    // Total distance form the starting location
    float totalDistance;
    
    // Location instances to save inetermediate locations
    CLLocation *tempNewLocation, *tempOldLocation;
    
    //objects
    NSMutableArray *objects;
    
    //order test_id
    NSString *orderTestID;
    
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *mapTypeSeg;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIButton *showMyLocation;

- (IBAction)reloadObjects:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)myLocation:(id)sender;

//Load objects on map
- (void)loadObjects:(CLLocationCoordinate2D)loc;

//Remove annotations from the map
- (void)removeAllAnnotations;

- (void)acceptTheOrder:(NSString *)test_id withName:(NSString *)name andPrice:(NSString *)price addDesc:(NSString *)desc;
- (void)acceptTheOrder:(id)object;

@end