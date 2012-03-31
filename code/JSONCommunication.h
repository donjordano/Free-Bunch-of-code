//
//  JSONCommunication.h
//  Created by Ivan Yordanov on 2/12/12.

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
