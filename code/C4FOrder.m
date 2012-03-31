//
//  C4FOrder.m
//  C4F
//
//  Created by Ivan Yordanov on 3/4/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "C4FOrder.h"

@implementation C4FOrder
@synthesize order, qrcode, answers, reference_id;

+(C4FOrder *)sharedInstance
{
    static dispatch_once_t predicate = 0;
    
    __strong static C4FOrder *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
    
    return instance;
}

@end
