//
//  RootViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 2/12/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController{
    IBOutlet UIWebView *web;
}

@property (strong, nonatomic) IBOutlet UIWebView *web;

- (IBAction)goToLogin:(id)sender;

@end
