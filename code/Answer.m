//
//  Answer.m
//
//  Created by Ivan Yordanov on 3/5/12.

#import "Answer.h"

@implementation Answer

@synthesize question_id, answer, skipped;

+(Answer *)sharedInstance
{
    static dispatch_once_t predicate = 0;
    
    __strong static Answer *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
	
    return instance;
}
@end
