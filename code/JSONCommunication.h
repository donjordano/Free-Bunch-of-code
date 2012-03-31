//
//  JSONCommunication.h
//  Created by Ivan Yordanov on 2/12/12.
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

@interface JSONCommunication : NSObject{
    NSMutableDictionary *errorDict;

}

@property(nonatomic, retain)NSMutableDictionary *errorDict;

//helpers methods
-(NSString *)getDevID;
-(void)errorDictInit;

//JSON Methods

//GetSession
-(NSDictionary *)getSession:(NSString *)username andPass:(NSString *)password;

//Reset Password
-(NSDictionary *)resetPassword:(NSString *)email;

//Update profile
-(NSDictionary *)updateProfile;

//Validate Session
-(NSDictionary *)validateSession:(NSString *)sessionId;

//GetVersion
-(NSDictionary *)getVersion;

//RegisterTester
-(NSDictionary *)registerTester:(NSString *)birthdate whitPassword:(NSString *)password email:(NSString *)email andSex:(NSNumber *)sex;

//GetOrders
-(NSDictionary *)getOrders:(NSDictionary *)param;

//AcceptOrder
-(NSDictionary *)acceptOrder:(NSString *)testID;

//submit test
-(NSDictionary *)submitTest:(NSString *)reference_id andQR:(NSString *)qrCode;

//submit answers
-(NSDictionary *)submitAnswers:(NSString *)answer andRef:(NSString *)refereneId forQID:(NSString *)questionId andSkip:(NSString *)skip;

//cancel test
-(void)cancelTest:(NSString *)referenceID;

//requestPayment
-(NSDictionary *)requestPayment;

//create dictionary ftom params and method name
-(NSDictionary *)createDictForMethod:(NSString *)method andParams:(NSDictionary *)params;

//Private json post request method
-(id)postRequest:(NSData *)reqData;

//Upload image
- (void) uploadPic:(UIImage *)image;

//show error alert
-(void)showAlert:(NSString *)msg;


@end
