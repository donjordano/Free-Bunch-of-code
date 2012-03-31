//
//  DB.h
//
//  Created by Ivan Yordanov on 2/12/12.


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
