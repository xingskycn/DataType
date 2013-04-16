//
//  MainViewController.h
//  DataType
//
//  Created by tju tju on 13-4-12.
//  Copyright (c) 2013年 tju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceInput.h"

@interface MainViewController : UIViewController<GCDAsyncUdpSocketDelegate,CheckFeedBackDelegate>
{
    VoiceInput * inputVoice;
    IBOutlet UIButton *btnIn;
    IBOutlet UIButton *btncon;
    BOOL isIn;
    IBOutlet UILabel *lblIP;
    IBOutlet UILabel *lblPort;
    IBOutlet UILabel *lblConnection;
}
@property (strong ,nonatomic) VoiceInput * inputVoice;
@property (strong ,nonatomic) UIButton * btnIn;
//@property (strong ,nonatomic) GCDAsyncUdpSocket *client;

-(IBAction)pressedInput:(id)sender;
-(IBAction)pressedCon:(id)sender;

@end
