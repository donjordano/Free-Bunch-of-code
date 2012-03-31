//
//  OrderQuestionsViewController.m
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "OrderQuestionsViewController.h"
#import "CircleCountDown/CircleDownCounter.h"
#import "QRCodeReader.h"

#import "NSString+MD5.h"
#import "NSArray+JSONCategories.h"

#import "C4FJSONCommunication.h"
#import "C4FSession.h"
#import "C4FOrder.h"
#import "C4FAnswer.h"
#import "C4FDB.h"

#import "ASIFormDataRequest.h"
#import "Config.h"

@implementation OrderQuestionsViewController

@synthesize timerView;
@synthesize resultsToDisplay;
@synthesize thQ;
@synthesize qrBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    C4FOrder *order = [C4FOrder sharedInstance];
    C4FDB *db = [C4FDB sharedInstance];
    json = [[C4FJSONCommunication alloc] init];
    
    referenceID = (NSString *)[[order.order objectForKey:@"order"] objectForKey:@"reference_id"];
    
    NSString *qr_code = [NSString stringWithFormat:@"%@" ,[db getQRCodeByReferenceID:referenceID]];  
    
    if ([qr_code length] != 0){
        self.navigationItem.leftBarButtonItem = nil;
        [order setQrcode:qr_code];
    }
    
    questions = [order.order objectForKey:@"questions"];
    
    [order setReference_id:referenceID];
    
    parentQuestions = [[NSMutableArray alloc] init];
    actions = [[NSMutableArray alloc] init];
    answers = [[NSMutableDictionary alloc] init];
    thQ = [[NSMutableDictionary alloc] init];
//    [thQ removeAllObjects];
    
    for (int i = 0; [questions count] > i; i++) {
        NSMutableDictionary *oneQ = [questions objectAtIndex:i];
        
        if ([[oneQ objectForKey:@"parent"] intValue] == 0) {
            [parentQuestions addObject:oneQ];
        } else {
            [actions addObject:oneQ];
        }
    }
    
    if ([order.order objectForKey:@"lastAnsweredQuestion_id"] == nil 
        || [order.order objectForKey:@"lastAnsweredQuestion_id"] == [NSNull null]) {
            [self showQuestion:[parentQuestions objectAtIndex:0]];
            parentOrder = 0;
    } else {
        int lastAnsweredId = [[order.order objectForKey:@"lastAnsweredQuestion_id"] intValue];
        
//       NSDictionary *lastAnswered =  [self getQuestion:[[order.order objectForKey:@"lastAnsweredQuestion_id"] intValue]];        
        NSDictionary *lastAnswered =  [self getQuestion:lastAnsweredId];        
        NSString *lastAnswer   = [NSString stringWithString:[order.order objectForKey:@"lastAnsweredQuestion_answer"]];
        
        int lastAnsweredParent = [[lastAnswered objectForKey:@"parent"] intValue];
        int lastAnsweredOrder  = [[lastAnswered objectForKey:@"order"] intValue];

        if (lastAnsweredParent == 0 && lastAnsweredOrder == [parentQuestions count]) {
            [self testIsFinished];
            return;
        } 
        
        if (lastAnsweredOrder == 0 && lastAnsweredParent != 0) {
            [self getParentQuestion:lastAnsweredId];
            return;
        } 
        
        if(lastAnsweredOrder != 0 && lastAnsweredParent == 0 ){
            //[self showQuestion:[self getQuestionByParent:lastAnsweredOrder+1]];
            [self nextQuestionByParent:lastAnsweredOrder andAnswer:lastAnswer];
            return;
        }
    }
}

- (NSDictionary *)getQuestion:(int)question_id
{
    C4FOrder *order = [C4FOrder sharedInstance];
    NSArray *Questions = (NSArray *)[order.order objectForKey:@"questions"];    

    NSDictionary *question = nil;
    
    for (int i = 0; [Questions count] > i; i++) {
        NSMutableDictionary *action = [Questions objectAtIndex:i];
        
        if ([[action objectForKey:@"question_id"] intValue] == question_id) {
            question = [NSDictionary dictionaryWithDictionary:action];
        }
    }
    
    return question;
}

- (NSDictionary *)getQuestionByParent:(int)parent
{
    C4FOrder *order = [C4FOrder sharedInstance];
    NSArray *Questions = (NSArray *)[order.order objectForKey:@"questions"];    

    NSDictionary *question = nil;
    
    for (int i = 0; [Questions count] > i; i++) {
        NSMutableDictionary *action = [Questions objectAtIndex:i];
        
        if ([[action objectForKey:@"order"] intValue] == parent) {
            question = [NSDictionary dictionaryWithDictionary:action];
        }
    }
    
    return question;
}

- (void)nextQuestionByParent:(int)parent andAnswer:(NSString *)answer
{
    NSDictionary *question = [self getQuestionByParent:parent];
 
    // TODO: The thQ existance in code doesn't make any sense, remove it when there is time
    //thQ = question;
    
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setQuestion_id:[question objectForKey:@"question_id"]];
    answers = [question objectForKey:@"answers"];
    
    NSDictionary *lastAnswer = [answers objectForKey:[NSString stringWithString:answer]];
    
    if ([[lastAnswer objectForKey:@"action"] isEqualToString:@"none"]) {
        question = [self getQuestionByParent:parent+1];
        
        // If we are at the last, show the last, not test finished
        if (!question)
            question = [self getQuestionByParent:parent];
             
        [self showQuestion:question];
    }
    else 
    {
        question = [self getQuestion:[[lastAnswer objectForKey:@"actionto"] intValue]];
        [self showQuestion:question];
    }
}

-(void)getParentQuestion:(int)parent
{
    if (parent != 0) {
        for (int i = 0; [questions count] > i; i++) {
            NSDictionary *action = [questions objectAtIndex:i];
            
            if ([[action objectForKey:@"question_id"] intValue] == parent) {
                if ([[action objectForKey:@"parent"] intValue] != 0) {
                    [self getParentQuestion:[[action objectForKey:@"parent"] intValue]];
                }
                else {
                    parentOrder = [parentQuestions indexOfObject:[self getQuestion:[[action objectForKey:@"question_id"] intValue]]] + 1;
                    
                    if ([parentQuestions count] > parentOrder) {
                        [self showQuestion:[parentQuestions objectAtIndex:parentOrder]];
                    }
                    else {
                        [self testIsFinished];
                    }
                }
            }
        }
    } else {
        parentOrder += 1;
        
        if ([parentQuestions count] > parentOrder) {
            [self showQuestion:[parentQuestions objectAtIndex:parentOrder]];
        }
        else {
            [self testIsFinished];
        }
    }
}


-(void)setSkip
{
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setSkipped:@"1"];
    C4FOrder *order = [C4FOrder sharedInstance];
    [A setAnswer:@"null"];
    
    [json submitAnswers:A.answer andRef:order.reference_id forQID:A.question_id andSkip:A.skipped];
    self.navigationItem.rightBarButtonItem = nil;
    
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
}

-(void)showQuestion:(NSDictionary *)question
{
    thQ = question;
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setQuestion_id:[question objectForKey:@"question_id"]];
    answers = [question objectForKey:@"answers"];
    
    int theParent = [[question objectForKey:@"parent"] intValue];
    int theOrder  = [[question objectForKey:@"order"] intValue];
    
    if (theParent == 0 && theOrder == [parentQuestions count]) {
        [self testIsFinished];
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    if ([[question objectForKey:@"optional"] intValue] == 1) {
        UIBarButtonItem *skipBtn = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStyleBordered target:self action:@selector(setSkip)];
        self.navigationItem.rightBarButtonItem = skipBtn;
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"question"] ||
        [[question objectForKey:@"action"] isEqualToString:@"undefined"]
        ) {
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(10, 20, 300, 50);
        title.textAlignment = UITextAlignmentCenter;
        title.text = [question objectForKey:@"title"];
        [self.view addSubview:title];
        
        if ([[question objectForKey:@"type"] isEqualToString:@"bool"] || [[question objectForKey:@"type"] isEqualToString:@"vote"]) {
            
            for (int i=1; [answers count]+1 > i; i++) {
                
                NSDictionary *answer = [answers objectForKey:[NSString stringWithFormat:@"answer%i",i]];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(theAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                
                NSString *titleString = [NSString stringWithFormat:@"%@", [answer objectForKey:@"text"]];
                CGSize fontSize = [titleString sizeWithFont:[UIFont systemFontOfSize:20.0]];
                [button setTitle:titleString forState:UIControlStateNormal];
                
                CGRect buttonFrame;
                
                float wdth;
                
                if (fontSize.width < 100) {
                    wdth = 100;
                }
                else {
                    wdth = fontSize.width;
                }
                
                float start_x;
                
                if (wdth > 100) {
                    start_x = (320-wdth)/2;
                }
                else {
                    start_x = 110;
                }
                
                if(i == 1)
                    //button.frame = CGRectMake(110, 80, 100, 55);
                    buttonFrame = CGRectMake(start_x, 80, wdth, 55);
                    //[button setFrame:buttonFrame];
                if (i == 2) 
                    //button.frame = CGRectMake(110, 145, 100, 55);
                    buttonFrame = CGRectMake(start_x, 145, wdth, 55);
                    //[button setFrame:buttonFrame];
                if (i == 3)
                    //button.frame = CGRectMake(110, 210, 100, 55);
                    buttonFrame = CGRectMake(start_x, 210, wdth, 55);
                    
                [button setFrame:buttonFrame];
                
                [self.view addSubview:button];
            }
        }
        
        if ([[question objectForKey:@"type"] isEqualToString:@"time"]) {
            for (int i=1; [answers count]+1 > i; i++) {
                NSDictionary *answer = [answers objectForKey:[NSString stringWithFormat:@"answer%i",i]];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                if (i==1) {
                    NSString *t1 = [NSString stringWithFormat:@"< %@", [answer objectForKey:@"text"]];
                    [button setTitle:t1 forState:UIControlStateNormal];
                }
                if (i==2) {
                    NSString *t2 = [NSString stringWithFormat:@"> %@", [answer objectForKey:@"text"]];
                    [button setTitle:t2 forState:UIControlStateNormal];
                }
                 [button addTarget:self action:@selector(theAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                if(i==1)
                    button.frame = CGRectMake(110, 80, 100, 55);
                if (i==2) 
                    button.frame = CGRectMake(110, 145, 100, 55);
                
                [self.view addSubview:button];
            }
        }
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"take_photo"]) {
        [self makePhoto];
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"write_comment"]) {
        [self writeComment];
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"count_time"]) {
        [self addCounterToView];
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"buy_something"]) {
        [self showOther];
    }
    
    if ([[question objectForKey:@"action"] isEqualToString:@"contact_person"]) {
        [self showOther];
    }
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    
    int min_time = [[question objectForKey:@"min_time"] intValue];
    
    if (min_time != 0) {
        [self setTimer:min_time];
    }
}

-(void)theAction:(id)sender
{
    NSInteger intIndex = ((UIControl *) sender).tag; 
    NSDictionary *answer = [answers objectForKey:[NSString stringWithFormat:@"answer%i",intIndex]];
    
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setAnswer:[NSString stringWithFormat:@"answer%i",intIndex]];
    [A setSkipped:@"0"];
    
    C4FOrder *order = [C4FOrder sharedInstance];
    
    [json submitAnswers:A.answer andRef:order.reference_id forQID:A.question_id andSkip:A.skipped];
    
    if ([answer objectForKey:@"actionto"] != nil) {
        [self showQuestion:[self getQuestion:[[answer objectForKey:@"actionto"] intValue]]];
    } else  {
        [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
    }
}

-(void)setQTittle
{
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 10, 300, 30);
    title.textAlignment = UITextAlignmentCenter;
    title.text = [thQ objectForKey:@"title"];
    [self.view addSubview:title];
}

-(void)writeComment
{
    [self setQTittle];

    writeComentLbl = [[UILabel alloc] init];
    writeComentLbl.frame = CGRectMake(10, 50, 300, 20);
    writeComentLbl.textAlignment = UITextAlignmentCenter;
    writeComentLbl.text = @"Write comment";
    
    //[self.view addSubview:writeComentLbl];
    //[self.view bringSubviewToFront:writeComentLbl];
    
    writeComment = [[UITextView alloc] init];
    writeComment.frame = CGRectMake(10, 70, 300, 100);
    writeComment.layer.borderWidth = 1.0f;
    writeComment.layer.borderColor = [UIColor blackColor].CGColor;
    writeComment.delegate = self;
    [writeComment setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:writeComment];
    [self.view bringSubviewToFront:writeComment];
    
    addComment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addComment setTitle:@"Add" forState:UIControlStateNormal];
    [addComment addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
    addComment.frame = CGRectMake(110, 180, 100, 55);
    [self.view addSubview:addComment];
    [self.view bringSubviewToFront:addComment];
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([writeComment isFirstResponder] && [touch view] != writeComment) {
        [writeComment resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)addComment
{
    [writeComentLbl removeFromSuperview];
    [writeComment removeFromSuperview];
    [addComment removeFromSuperview];
    
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setAnswer:writeComment.text];
    [A setSkipped:@"0"];
    
    C4FOrder *order = [C4FOrder sharedInstance];
    [json submitAnswers:A.answer andRef:order.reference_id forQID:A.question_id andSkip:A.skipped];

    NSDictionary *answer = [answers objectForKey:@"answer1"];    
    
    if ([answer objectForKey:@"actionto"] != nil) {
        [self showQuestion:[self getQuestion:[[answer objectForKey:@"actionto"] intValue]]];
    } else {
        [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
    }
}

- (void)setTimer:(int)minutes
{
    [self.view addSubview:timerView];
    [self.view bringSubviewToFront:timerView];
    
    //self.navigationItem.rightBarButtonItem = nil;
    [CircleDownCounter showCircleDownWithSeconds:minutes*60.0f
                                          onView:timerView
                                        withSize:kDefaultCounterSize
                                         andType:CircleDownCounterTypeIntegerDecre];
    
    self.view.userInteractionEnabled = NO;
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:minutes*60.0f
                                     target:self
                                   selector:@selector(enableAfterTime)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)enableAfterTime
{
    [aTimer invalidate];
    aTimer = nil;
    self.view.userInteractionEnabled = YES;
}


- (void)showOther
{
    [self setQTittle];
    
    UIButton *other = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    other.frame = CGRectMake(50, 80, 100, 55);
    [other setTitle:@"Yes" forState:UIControlStateNormal];
    [other addTarget:self action:@selector(showOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    other.tag = 1;
    [self.view addSubview:other];
    
    UIButton *other1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    other1.frame = CGRectMake(170, 80, 100, 55);
    [other1 setTitle:@"No" forState:UIControlStateNormal];
    [other1 addTarget:self action:@selector(showOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    other1.tag = 2;
    [self.view addSubview:other1];
}

- (void)showOtherAction:(id)sender
{
    NSInteger intIndex = ((UIControl *) sender).tag; 
    NSDictionary *answer = [answers objectForKey:[NSString stringWithFormat:@"answer%i",intIndex]];
    
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setAnswer:[NSString stringWithFormat:@"answer%i",intIndex]];
    [A setSkipped:@"0"];
    
    C4FOrder *order = [C4FOrder sharedInstance];
    [json submitAnswers:A.answer andRef:order.reference_id forQID:A.question_id andSkip:A.skipped];
    
    if ([answer objectForKey:@"actionto"] != nil) {
        [self showQuestion:[self getQuestion:[[answer objectForKey:@"actionto"] intValue]]];
    } else {
        [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
    }
}

- (void)startCountTimer
{
    counter = 0;
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1 
                                              target:self 
                                            selector:@selector(updateTimerNoOne:) 
                                            userInfo:nil 
                                             repeats:YES];
    start.userInteractionEnabled = NO;
    stop.userInteractionEnabled = YES;
}

- (void)stopCountTimer
{
    [aTimer invalidate];
    aTimer = nil;
    
    C4FAnswer *A = [C4FAnswer sharedInstance];
    [A setAnswer:[NSString stringWithFormat:@"%f", (float)(counter/60)]];
    [A setSkipped:@"0"];

    C4FOrder *order = [C4FOrder sharedInstance];
    
    [json submitAnswers:A.answer andRef:order.reference_id forQID:A.question_id andSkip:A.skipped];
    
    NSDictionary *answer = [answers objectForKey:@"answer1"];
    
    if ([answer objectForKey:@"actionto"] != nil) {
        [self showQuestion:[self getQuestion:[[answer objectForKey:@"actionto"] intValue]]];
    } else {
        [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
    }
    
    start.userInteractionEnabled = YES;
}

- (void)updateTimerNoOne:(NSTimer *)timer 
{
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(20, 60, 200, 50);
    title.textAlignment = UITextAlignmentCenter;
    title.text = [NSString stringWithFormat:@"Time: %i", counter++];
    
    [self.view addSubview:title];
}

- (void)addCounterToView
{
    [self setQTittle];
    
    start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame = CGRectMake(50, 130, 100, 55);
    start.backgroundColor = [UIColor greenColor];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startCountTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    stop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stop.frame = CGRectMake(170, 130, 100, 55);
    stop.backgroundColor = [UIColor redColor];
    [stop setTitle:@"Stop" forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopCountTimer) forControlEvents:UIControlEventTouchUpInside];
    stop.userInteractionEnabled = NO;
    [self.view addSubview:stop];
}

- (void)viewDidUnload
{
    [self setTimerView:nil];
    [self setQrBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takeQR:(id)sender 
{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    
    widController.readers = readers;
    
    [self presentModalViewController:widController animated:YES];
}

- (void)submitTest:(id)sender 
{
    C4FOrder *order = [C4FOrder sharedInstance];
    
    if ([order.qrcode length] != 0) {
        NSDictionary *result = [json submitTest:order.reference_id andQR:order.qrcode];
        
        if ([[result objectForKey:@"success"] intValue] == 1) {
            float money = [[result objectForKey:@"gain"] floatValue];
            
            NSString *txt = [NSString stringWithFormat:@"Test successfully completed. You've earn %.2f EUR", money];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"C4F" message:txt delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            alert.tag = 100;
            [alert show];
            
            C4FSession *session = [C4FSession sharedInstance];
            float lastMoney = [session.balance floatValue];
            [session setBalance:[NSString stringWithFormat:@"%.2f", lastMoney+money]];
        }
    }
    else {
        // Alert when QR code is not scanned
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:@"Please scan the QR code"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result 
{
    C4FOrder *order = [C4FOrder sharedInstance];
    
    NSString *resultSalted = [NSString stringWithFormat:@"%@C4F", result];
    NSString *qrcodehash = [NSString stringWithFormat:@"%@", [[order.order objectForKey:@"order"] objectForKey:@"qrcodehash"]];    
    
    if ([[NSString stringWithMD5Hash:resultSalted] isEqualToString:[qrcodehash uppercaseString]]) {
        //not hashed
        [order setQrcode:result];
        C4FDB *db = [C4FDB sharedInstance];
        [db addQRCodeByReferenceID:order.reference_id qrCode:order.qrcode];
        [self dissmisQRCodeView];
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [self dissmisQRCodeView];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"C4F Error" message:@"Wrong QR Code!\nPlease make new scan!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        alert.tag = 0;
        [alert show];
    }
}


- (void)dissmisQRCodeView
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Make Photo

- (void)makePhoto
{
	// Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    // Delegate is self
	imagePicker.delegate = self;
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
    
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alert.tag == 0 && buttonIndex == 1) {
        [self performSelector:@selector(takeQR:) withObject:nil];
    }
    
    if (alert.tag == 1 || alert.tag == 100) {
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    /*
    UIAlertView *alert;
    
	// Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
	else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    
    alert.tag = 1;
    [alert show];
     */
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //sent image here    
    if (image) {
        C4FOrder *order = [C4FOrder sharedInstance];
        C4FAnswer *A = [C4FAnswer sharedInstance];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:kC4FURL];
        [request addPostValue:[NSString stringWithFormat:@"questionid_%@", A.question_id] forKey:@"name"];
        [request addPostValue:@"sess" forKey:@"session_id"];
        [request addPostValue:[json getDevID] forKey:@"devID"];
        [request addPostValue:order.reference_id forKey:@"referenceId"];
        [request addData:image withFileName:[NSString stringWithFormat:@"questionid_%@", A.question_id] andContentType:@"image/jpeg" forKey:@"photos"];
        
        NSDictionary *answer = [answers objectForKey:@"answer1"];
        if ([answer objectForKey:@"actionto"] != nil) {
            [self showQuestion:[self getQuestion:[[answer objectForKey:@"actionto"] intValue]]];
        } else {
            [self getParentQuestion:[[thQ objectForKey:@"parent"] intValue]];
        }
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}

//finished test
- (void)testIsFinished
{
    // Clean the last question screen
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finish.frame = CGRectMake(50, 80, 220, 55);
    
    [finish setTitle:@"Submit test" forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(submitTest:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:finish];
}

@end
