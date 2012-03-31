//
//  C4FAnswer.m
//  C4F
//
//  Created by Ivan Yordanov on 3/5/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "C4FAnswer.h"

@implementation C4FAnswer

@synthesize question_id, answer, skipped;

+(C4FAnswer *)sharedInstance
{
    static dispatch_once_t predicate = 0;
    
    __strong static C4FAnswer *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
	
    return instance;
}
@end
