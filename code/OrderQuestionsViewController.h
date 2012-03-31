//
//  OrderQuestionsViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import <QuartzCore/QuartzCore.h>

@class C4FJSONCommunication;

@interface OrderQuestionsViewController : UIViewController<ZXingDelegate, UINavigationControllerDelegate, 
UIImagePickerControllerDelegate, UITextViewDelegate>{
    NSString *resultsToDisplay;
    
    NSMutableArray *parentQuestions;
    NSMutableArray *actions;
    
    C4FJSONCommunication *json;
    NSString *referenceID;
    NSString *questionID;
    NSString *theAnswer;
    NSInteger skipped;
    
    NSDictionary *answers;

    UILabel *writeComentLbl;
    UITextView *writeComment;
    UIButton *addComment;
    
    IBOutlet UIView *timerView;
    
    NSTimer *aTimer;
    int counter;
    int parentOrder;
    
    NSDictionary *thQ;
    NSArray *questions;
    
    UIButton *start;
    UIButton *stop;
}

@property (strong, nonatomic) IBOutlet UIView *timerView;
@property (nonatomic, copy) NSString *resultsToDisplay;
@property (strong, nonatomic) NSDictionary *thQ;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *qrBtn;

- (IBAction)takeQR:(id)sender;
- (void)showQuestion:(NSDictionary *)question;
- (NSDictionary *)getQuestion:(int)question_id;
- (NSDictionary *)getQuestionByParent:(int)parent;
- (void)nextQuestionByParent:(int)parent andAnswer:(NSString *)answer;

- (void)getParentQuestion:(int)parent;
- (void)makePhoto;
- (void)theAction:(id)sender;
- (void)setTimer:(int)minutes;
- (void)startCountTimer;
- (void)updateTimerNoOne:(NSTimer *)timer;
- (void)dissmisQRCodeView;
- (void)addComment;
- (void)writeComment;
- (void)enableAfterTime;
- (void)addCounterToView;
- (void)showOther;
- (void)setSkip;
- (void)testIsFinished;
- (void)setQTittle;
- (void)showOtherAction:(id)sender;
- (void)submitTest:(id)sender;

@end
