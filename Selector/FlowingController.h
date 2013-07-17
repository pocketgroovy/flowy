//
//  FlowingController.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/17/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface FlowingController : UIViewController <MFMailComposeViewControllerDelegate >
{
AVAudioRecorder *recorder;
NSTimer *levelTimer;
double lowPassResults;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonMailItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarButtom;
@property (weak, nonatomic) IBOutlet UIToolbar *barButtonEmailItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonTryItem;

- (void)levelTimerCallback:(NSTimer *)timer;
@end
