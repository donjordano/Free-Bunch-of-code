//
//  C4FSession.m
//  C4F
//
//  Created by Ivan Yordanov on 2/23/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "C4FSession.h"

@implementation C4FSession

@synthesize session_id, mail, pass, sex, birthdate, test_id, iban, fullname, balance;

+(C4FSession *)sharedInstance
{
    // Singleton done right
    static dispatch_once_t predicate = 0;
    
    __strong static C4FSession *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
    
    return instance;
}

@end
