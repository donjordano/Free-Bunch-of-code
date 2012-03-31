//
//  Answer.h
//  Created by Ivan Yordanov on 3/5/12.

#import <Foundation/Foundation.h>

@interface Answer : NSObject{
    NSString *question_id;
    NSString *answer;
    NSString *skipped;
}

@property (strong, nonatomic) NSString *question_id;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *skipped;

+ (C4FAnswer *)sharedInstance;

@end
