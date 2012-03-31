//
//   Order.m
//   
//
//  Created by Ivan Yordanov on 3/4/12.

#import " Order.h"

@implementation  Order
@synthesize order, qrcode, answers, reference_id;

+( Order *)sharedInstance
{
    static dispatch_once_t predicate = 0;
    
    __strong static  Order *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] init]; 
    });
    
    return instance;
}

@end
