//
//  OrderQuestionsViewController.h
//  Created by Ivan Yordanov on 2/28/12.
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

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import <QuartzCore/QuartzCore.h>

@class  JSONCommunication;

@interface OrderQuestionsViewController : UIViewController<ZXingDelegate, UINavigationControllerDelegate, 
UIImagePickerControllerDelegate, UITextViewDelegate>{
    NSString *resultsToDisplay;
    
    NSMutableArray *parentQuestions;
    NSMutableArray *actions;
    
     JSONCommunication *json;
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
