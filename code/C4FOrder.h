//
//  C4FOrder.h
//  C4F
//
//  Created by Ivan Yordanov on 3/4/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4FOrder : NSObject{
    NSString *reference_id;
    NSDictionary *order;
    NSMutableArray *answers;
    NSString *qrcode;
}

@property (strong, nonatomic) NSDictionary *order;
@property (strong, nonatomic) NSString *qrcode;
@property (strong, nonatomic) NSMutableArray *answers;
@property (strong, nonatomic) NSString *reference_id;

+ (C4FOrder *)sharedInstance;

@end
