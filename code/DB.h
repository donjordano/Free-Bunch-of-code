//
//  DB.h
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


@interface DB  {
    NSMutableArray *idList;
    NSDictionary *row;
}

//DB initialization
+(DB *)sharedInstance;
- (DB *) initWithMissionsDBFilename;
- (void)reloadIdList;

//temp method
- (void)insertObject:(float)lat andLong:(float)longt;

//user
- (void)addUserToDB:(NSDictionary *)dict;
- (NSDictionary *)getUserFromDB;
- (void)deleteUserFromDB;

//orders
- (void)addOrderToDB:(NSDictionary *)dict;
//-(void)addLastAnsweredQuestion:(NSNumber *)row_id answer:(NSString *)asnwer;
-(void)addQRCodeByReferenceID:(NSString *)reference_id qrCode:(NSString *)code;
-(NSString *)getQRCodeByReferenceID:(NSString *)reference_id;
//-(void)addLastAnswerJSON:(NSNumber *)row_id withJson:(NSDictionary *)json;
-(NSDictionary *)getOrder;

@end
