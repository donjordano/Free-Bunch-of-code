//
//  OrderDesignerQRViewController.h
//   
//
//  Created by Ivan Yordanov on 2/28/12.

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"

@interface OrderDesignerQRViewController : UIViewController<ZXingDelegate> {
  NSString *resultsToDisplay;
}
@property (nonatomic, copy) NSString *resultsToDisplay;
@end
