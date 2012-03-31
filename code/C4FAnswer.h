//
//  C4FAnswer.h
//  C4F
//
//  Created by Ivan Yordanov on 3/5/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C4FAnswer : NSObject{
    NSString *question_id;
    NSString *answer;
    NSString *skipped;
}

@property (strong, nonatomic) NSString *question_id;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *skipped;

+ (C4FAnswer *)sharedInstance;

@end
