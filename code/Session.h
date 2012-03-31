//
//   Session.h
//  Created by Ivan Yordanov on 2/23/12.
//This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
//http://creativecommons.org/licenses/by-nc-sa/3.0/
//CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE LEGAL SERVICES. 
//DISTRIBUTION OF THIS LICENSE DOES NOT CREATE AN ATTORNEY-CLIENT RELATIONSHIP. 
//CREATIVE COMMONS PROVIDES THIS INFORMATION ON AN "AS-IS" BASIS. 
//CREATIVE COMMONS MAKES NO WARRANTIES REGARDING THE INFORMATION PROVIDED, 
//AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM ITS USE. 
//THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
// ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW.
//ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
//Copyright (c) Ivan Yordanov 2012

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
