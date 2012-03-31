//
//   Session.h
//   
//
//  Created by Ivan Yordanov on 2/23/12.

#import <Foundation/Foundation.h>

@interface  Session : NSObject{
    NSString *session_id;
    NSString *mail;
    NSString *pass;
    NSNumber *sex;
    NSString *birthdate;
    NSString *test_id;
    NSString *iban;
    NSString *fullname;
    NSString *balance;
}

@property(strong, nonatomic) NSString *session_id;
@property(strong, nonatomic) NSString *mail;
@property(strong, nonatomic) NSString *pass;
@property(strong, nonatomic) NSNumber *sex;
@property(strong, nonatomic) NSString *birthdate;
@property(strong, nonatomic) NSString *test_id;
@property(strong, nonatomic) NSString *iban;
@property(strong, nonatomic) NSString *fullname;
@property(strong, nonatomic) NSString *balance;

//singleton
+ ( Session *)sharedInstance;

@end
