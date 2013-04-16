//
//  MainViewController.m
//  DataType
//
//  Created by tju tju on 13-4-12.
//  Copyright (c) 2013年 tju. All rights reserved.
//

#import "MainViewController.h"

#define HOST_IP @"192.168.1.233"
#define HOST_PORT 19998

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize inputVoice;
@synthesize btnIn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
                
        inputVoice = [[VoiceInput alloc] init];
        inputVoice.delegate = self;
        inputVoice.dstHost = HOST_IP;
        inputVoice.dstPort = HOST_PORT;
                isIn = NO;
        
    }
    return self;
}


-(IBAction)pressedInput:(id)sender
{
    if (isIn == NO) {
        [inputVoice start];
        [btnIn setTitle:@"loading" forState:UIControlStateNormal];
        isIn = YES; 
    }
    else {
        [inputVoice stop];
        [btnIn setTitle:@"start" forState:UIControlStateNormal];
        isIn = NO;
    }

}
-(IBAction)pressedCon:(id)sender
{
    //判断socket是否联通；
//    NSError *err = nil;  
    NSData *data = [[NSString stringWithFormat:@"isOpen"] dataUsingEncoding:NSUTF8StringEncoding];
    
    [inputVoice.socket sendData:data toHost:HOST_IP port:HOST_PORT withTimeout:-1 tag:0];
    
//    if (![inputVoice.socket connectToHost:HOST_IP onPort:HOST_PORT error:&err]) {
//        lblConnection.text = @"Connection is failed!";
//        lblConnection.textColor = [UIColor redColor];
//        
//    } 
//    else {
//        lblConnection.text = @"Connection is successful!";
//        lblConnection.textColor = [UIColor blackColor];
//    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init lable text;
    lblIP.text = [NSString stringWithFormat:@"IP:%@",HOST_IP];
    lblPort.text = [NSString stringWithFormat:@"端口: %i",HOST_PORT];
    lblConnection.text = @" testing ";

   
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)changeTheLable:(NSString *)lableText
{
	
	if ([lableText isEqualToString:@"isOpen"])
	{
            lblConnection.text = @"Connection is successful!";
            lblConnection.textColor = [UIColor blackColor];
	}
	else
	{
            lblConnection.text = @"Connection is failed!";
            lblConnection.textColor = [UIColor redColor];
	}
}



@end
