//
//  RootViewController.h
//  Created by Ivan Yordanov on 2/12/12.

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController{
    IBOutlet UIWebView *web;
}

@property (strong, nonatomic) IBOutlet UIWebView *web;

- (IBAction)goToLogin:(id)sender;

@end
