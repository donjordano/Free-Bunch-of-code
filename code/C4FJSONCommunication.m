//
//  C4FJSONCommunication.m
//  C4F
//
//  Created by Ivan Yordanov on 2/12/12.
//  Copyright (c) 2012 ITEco. All rights reserved.

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#import "C4FJSONCommunication.h"
#import "C4FSession.h"
#import "C4FDB.h"

#import "NSString+UUID.h"
#import "NSDictionary+JSONCategories.h"
#import "Config.h"

@implementation C4FJSONCommunication

@synthesize errorDict = _errorDict;

-(id)init{
    if (self != [super init]) {
        self = [super init];
    }
    
    return self;
}

//helpers methods
-(NSString *)getDevID
{
    // DO NOT TOUCH IT FOR NOW
    //deprecated
    return [[UIDevice currentDevice] uniqueIdentifier];
    
    // Calculates Univeral Unique Identifier instead of depricated uniqueIdentifier
    //return [NSString uuid];
}

-(void)errorDictInit{
    errorDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"General failure of the server", [NSNumber numberWithInt:1],
                 @"Session ID is invalid", [NSNumber numberWithInt:2],
                 @"Provided method is not found on server", [NSNumber numberWithInt:3],
                 @"Password send in GetSession is empty or length is lower than required", [NSNumber numberWithInt:100],
                 @"Wrong email or password", [NSNumber numberWithInt:101], 
                 @"Administrator is disabled this user account", [NSNumber numberWithInt:102],
                 @"Email verification is not complete", [NSNumber numberWithInt:103], 
                 @"Password for registration is too short", [NSNumber numberWithInt:201],
                 @"Email send for registration is invalid", [NSNumber numberWithInt:202],
                 @"Sex is invalid", [NSNumber numberWithInt:203], 
                 @"Email provided for registration is already in use", [NSNumber numberWithInt:204],
                 @"Birthdate is invalid", [NSNumber numberWithInt:205],
                 @"Geo coordinates are wrong or missing", [NSNumber numberWithInt:301],
                 @"This user already have one incomplete test", [NSNumber numberWithInt:401],
                 @"This test already reach maximum executions", [NSNumber numberWithInt:402], 
                 @"Reference is not available",[NSNumber numberWithInt:501],
                 @"No picture to send", [NSNumber numberWithInt:502],
                 @"Error uploading picture, no question id", [NSNumber numberWithInt:503],
                 @"Wrong question id for this test", [NSNumber numberWithInt:504],
                 @"Error saving picture on server", [NSNumber numberWithInt:505],
                 @"No answers are submited", [NSNumber numberWithInt:600],
                 @"Wrong question id for submiting answer", [NSNumber numberWithInt:601],
                 @"No answer is provided, and question is not skipped", [NSNumber numberWithInt:602],
                 @"QR code is invalide", [NSNumber numberWithInt:603],
                 @"Some question do not have answers", [NSNumber numberWithInt:604],
                 @"Balance is too low",[NSNumber numberWithInt:701],
                 @"No provided IBAN in user profile",[NSNumber numberWithInt:702] ,nil];
}

//JSON Methods
//GetSession
-(NSDictionary *)getSession:(NSString *)username andPass:(NSString *)password
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: username, @"email", 
                                                                       password, @"password", 
                                                                       [self getDevID], @"devID", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"GetSession" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}


//Reset Password
-(NSDictionary *)resetPassword:(NSString *)email
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"ResetPassword" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}

//Update profile
-(NSDictionary *)updateProfile
{
    C4FDB *db = [C4FDB sharedInstance];
    
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
        
    C4FSession *session = [C4FSession sharedInstance];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:session.pass, @"password",
                                                                        session.sex, @"sex", 
                                                                        session.birthdate, @"birthdate",
                                                                        session.fullname, @"username",
                                                                        session.iban, @"bank_account",
                                                                        [userData objectForKey:@"session_id"], @"session_id",
                                                                        [self getDevID], @"devID", nil];
        
    NSDictionary *dict = [self createDictForMethod:@"UpdateProfile" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}


//Validate Session
-(NSDictionary *)validateSession:(NSString *)sessionId
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sessionId, @"session_id",
                                                                    [self getDevID], @"devID", nil];
    NSDictionary *dict = [self createDictForMethod:@"ValidateSession" andParams:params];
    
    return [self postRequest:[dict toJSON]];
 }

//GetVersion
-(NSDictionary *)getVersion
{
    NSDictionary *dict = [self createDictForMethod:@"GetVersion" andParams:nil];
    return [self postRequest:[dict toJSON]];
 }

//RegisterTester
-(NSDictionary *)registerTester:(NSString *)birthdate whitPassword:(NSString *)password email:(NSString *)email andSex:(NSNumber *)sex
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:birthdate, @"birthdate",
                                                                      password, @"password",
                                                                      email, @"email",
                                                                      sex, @"sex", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"RegisterTester" andParams:params];
    
    return [self postRequest:[dict toJSON]];
 }

//GetOrders
-(NSDictionary *)getOrders:(NSDictionary *)params
{
    NSDictionary *dict = [self createDictForMethod:@"GetOrders" andParams:params];
    
    return [self postRequest:[dict toJSON]];
 }

//AcceptOrder
-(NSDictionary *)acceptOrder:(NSString *)testID
{
    C4FDB *db = [C4FDB sharedInstance];
    
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:testID, @"test_id",
                                                                      [userData objectForKey:@"session_id"], @"session_id",
                                                                      [self getDevID], @"devID", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"AcceptOrder" andParams:params];
    
    
    return [self postRequest:[dict toJSON]];
 
 }

//submit test
-(NSDictionary *)submitTest:(NSString *)reference_id andQR:(NSString *)qrCode
{
    C4FDB *db = [C4FDB sharedInstance];
    
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:reference_id, @"reference_id", 
                            qrCode, @"qrcode", 
                            [userData objectForKey:@"session_id"], @"session_id",
                            [self getDevID], @"devID", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"SubmitTest" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}

//submit answers
-(NSDictionary *)submitAnswers:(NSString *)answer andRef:(NSString *)refereneId forQID:(NSString *)questionId andSkip:(NSString *)skip
{
    C4FDB *db = [C4FDB sharedInstance];
    
    int qid = (int)[questionId intValue];
    NSDictionary *ans = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:qid], @"question_id", answer, @"answer", [NSNumber numberWithInt:[skip intValue]], @"skipped", nil];
    NSArray *answers = [NSArray arrayWithObject:ans];
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:refereneId, @"referenceId", 
                                                                      [userData objectForKey:@"session_id"], @"session_id",
                                                                      [self getDevID], @"devID", answers, @"answers", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"SubmitAnswers" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}

//cancel test
-(void)cancelTest:(NSString *)referenceID
{
    C4FDB *db = [C4FDB sharedInstance];
    C4FSession *session = [C4FSession sharedInstance];
    
    NSString *user_data_str = [NSString stringWithFormat:@"%@",[[db getUserFromDB] objectForKey:@"user_data"]];
    NSDictionary *userData = [NSDictionary dictionaryWithString:user_data_str];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:referenceID, @"referenceId", 
                            [userData objectForKey:@"session_id"], @"session_id",
                            [self getDevID], @"devID", nil];
    
    NSDictionary *dict = [self createDictForMethod:@"CancelTest" andParams:params];
    
    [self postRequest:[dict toJSON]];
    
    NSDictionary *result = [self getSession:session.mail andPass:session.pass];
    
    [session setSession_id:[result objectForKey:@"session_id"]];
    
    NSString *user_data_string = [result toStringFromJSON];
    
    [db addUserToDB:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"id", user_data_string, @"user_data",nil]];
}

//requestPayment
-(NSDictionary *)requestPayment
{
    C4FSession *session = [C4FSession sharedInstance];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:session.session_id, @"session_id",
                            [self getDevID], @"devID",nil];
    NSDictionary *dict = [self createDictForMethod:@"RequestPayment" andParams:params];
    
    return [self postRequest:[dict toJSON]];
}

//create dictionary and params for json
-(NSDictionary *)createDictForMethod:(NSString *)method andParams:(NSDictionary *)params
{
    NSArray *paramsArr = [NSArray arrayWithObject:params];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:method, @"method", paramsArr, @"params", @"", @"id", nil];
    
    return dict;
}

//Priavte json post request method
-(id)postRequest:(NSData *)reqData
{
    //the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kC4FURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    //bind request with reqData
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [reqData length]] forHTTPHeaderField:@"Content-Lenght"];
    [request setHTTPBody:reqData];

    //send sync request
    NSURLResponse *response = nil;
    __autoreleasing NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Do not crash if there is no internet connection
    if (result != nil)
    {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:&error];
            
        if (error == nil){
            if ([json objectForKey:@"result"] != [NSNull null]) {
                return [json objectForKey:@"result"];
            }
            else{
                [self errorDictInit];
                NSString *errorMsg = [NSString stringWithFormat:@"%@", [errorDict objectForKey:[[json objectForKey:@"error"] objectForKey:@"errorID"]]];
                [self showAlert:errorMsg];
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    // No internet connection - sendSynchronousRequest returns nil
    else {
        return nil;
    }
}

/*
 input type="file" name="questionid_36"
 input type="file" name="questionid_37"
 то това файловете, които ще се сбмитнат ще имат имена на частите questionid_36 и questionid_37.
 Сщо така, в замия POST трябва да има полетата:
 devID,session_id,reference_id за да знаем кой качва и кде качва.
 */

//Upload image
- (void) uploadPic:(UIImage *)image
{    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    // create the connection
    NSMutableURLRequest *uploadImageReq = [NSMutableURLRequest requestWithURL:kC4FURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    // change type to POST (default is GET)
    [uploadImageReq setHTTPMethod:@"POST"];
    
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // header value, user session ID added
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // set header
    [uploadImageReq addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    // create data
    NSMutableData *postBody = [NSMutableData data];
    
    // title part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // desc part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"desc\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    /*[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpeg\"\r\n", self.chosenImage.imgTitle ] dataUsingEncoding:NSUTF8StringEncoding]];*/
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[NSData dataWithData:imageData]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *s = [[NSString alloc] initWithData:postBody encoding:NSASCIIStringEncoding];
    NSLog(@"%@", s);
    
    // add body to post
    [uploadImageReq setHTTPBody:postBody];
    
    // pointers to some necessary objects
    NSURLResponse* response;
    NSError* error;
    
    // synchronous filling of data from HTTP POST response
    NSData *responseData = [NSURLConnection sendSynchronousRequest:uploadImageReq returningResponse:&response error:&error];
    
    if (error)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    // convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes]
                                                        length:[responseData length]
                                                      encoding:NSUTF8StringEncoding];
    
    // see if we get a welcome result
    NSLog(@"%@", responseString);
    //[self responseHandler:responseString];
}

//show error alert
-(void)showAlert:(NSString *)msg{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"C4F Error" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
