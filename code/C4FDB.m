//
//  C4FDB.m
//  C4F
//
//  Created by Ivan Yordanov on 2/12/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "C4FDB.h"

@implementation C4FDB

static NSString * const kLocationTableName = @"objects";
static NSString * const kOrderTableName    = @"orders";
static NSString * const kUserTableName     = @"user";
static NSString * const kMissionsDBName    = @"c4f.db";

#pragma mark -
#pragma mark DB initialization

//DB initialization
+ (C4FDB *)sharedInstance 
{
    // Singleton done right
    static dispatch_once_t predicate = 0;
    
    __strong static C4FDB *instance = nil;
    
    dispatch_once(&predicate, ^{ 
        instance = [[self alloc] initWithMissionsDBFilename]; 
    });
    
    return instance;
}

- (C4FDB *) initWithMissionsDBFilename
{
    if ((self = (C4FDB *) [super initWithDBFilename:kMissionsDBName])) {
		[self reloadIdList];
    }

    return self;
}

- (void)reloadIdList
{
	if(!idList) idList = [[NSMutableArray alloc] init];
}

- (void)insertObject:(float)lat andLong:(float)longt
{
     //NSLog(@"Function: %s", __FUNCTION__);
    self.tableName = kLocationTableName;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    [dict setValue:[NSNumber numberWithDouble:longt] forKey:@"long"];
    
    [self insertRow:dict];
}

//user
- (void)addUserToDB:(NSDictionary *)dict
{
    [self deleteUserFromDB];
    self.tableName = kUserTableName;
  
    [self insertRow:dict];
}

- (NSDictionary *)getUserFromDB
{
    self.tableName = kUserTableName;
	return [self getRow:[NSNumber numberWithInt:1]];
}

- (void)deleteUserFromDB
{
    [self doQuery:@"DELETE FROM USER WHERE id = 1"];
}

//orders
- (void)addOrderToDB:(NSDictionary *)dict
{
    self.tableName = kOrderTableName;
    [self doQuery:@"delete from orders where id = 1"];
    NSString *order_json = [NSString stringWithFormat:@"%@", dict];
    NSDictionary *insertDict = [NSDictionary dictionaryWithObjectsAndKeys:order_json, @"order_json",nil];
    [self insertRow:insertDict];
}

//-(void)addLastAnsweredQuestion:(NSNumber *)row_id answer:(NSString *)asnwer;
//-(void)addLastAnswerJSON:(NSNumber *)row_id withJson:(NSDictionary *)json;


//insert QR code in DB for given reference id
- (void)addQRCodeByReferenceID:(NSString *)reference_id qrCode:(NSString *)code
{
    self.tableName = kOrderTableName;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:code, @"qr_code", reference_id, @"reference_id", nil];     
    [self insertRow:dict];

    //[self updateRowByReferenceID:dict :reference_id];
}

//get QR cide frm db by given reference id
- (NSString *)getQRCodeByReferenceID:(NSString *)reference_id
{    
    [idList removeAllObjects];
    NSString *query = [NSString stringWithFormat:@"select qr_code from orders where reference_id = '%@'", reference_id];
	
    for (row in [self getQuery:query]) {
		[idList addObject:[row objectForKey:@"qr_code"]];
	}  
    
    NSString *ret;
    if ([idList count] != 0) {
        ret = [NSString stringWithFormat:@"%@", [idList objectAtIndex:0]];
    } 
    else {
        ret = @"";
    }
    
	return ret;
}

- (NSDictionary *)getOrder
{
    NSString * query = @"select order_json from orders where id = 1";
    [self prepareQuery:query];
    return [self getPreparedRow];
}

@end
