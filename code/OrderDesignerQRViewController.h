//
//  OrderDesignerQRViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@interface OrderDesignerQRViewController : UIViewController<ZXingDelegate> {
  NSString *resultsToDisplay;
}
@property (nonatomic, copy) NSString *resultsToDisplay;
@end
