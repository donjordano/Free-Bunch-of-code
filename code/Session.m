//
//   Session.m
//   
//
//  Created by Ivan Yordanov on 2/23/12.

#import "Session.h"

@implementation  Session

@synthesize session_id, mail, pass, sex, birthdate, test_id, iban, fullname, balance;

+(Session *)sharedInstance
{
    // Singleton done right
    static dispatch_once_t predicate = 0;
    
    __strong static  Session *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
    
    return instance;
}

@end
