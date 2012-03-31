//
//   Order.h
//   
//
//  Created by Ivan Yordanov on 3/4/12.

#import <Foundation/Foundation.h>

@interface  Order : NSObject{
    NSString *reference_id;
    NSDictionary *order;
    NSMutableArray *answers;
    NSString *qrcode;
}

@property (strong, nonatomic) NSDictionary *order;
@property (strong, nonatomic) NSString *qrcode;
@property (strong, nonatomic) NSMutableArray *answers;
@property (strong, nonatomic) NSString *reference_id;

+ ( Order *)sharedInstance;

@end
