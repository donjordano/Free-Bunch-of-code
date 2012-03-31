//
//  C4FDB.h
//  C4F
//
//  Created by Ivan Yordanov on 2/12/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWDB.h"

@interface C4FDB : BWDB {
    NSMutableArray *idList;
    NSDictionary *row;
}

//DB initialization
+(C4FDB *)sharedInstance;
- (C4FDB *) initWithMissionsDBFilename;
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
