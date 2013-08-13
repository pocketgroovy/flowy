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
#import <Social/Social.h>
#import "cocos2d.h"

@interface FlowingController : UIViewController <MFMailComposeViewControllerDelegate, CCDirectorDelegate, UINavigationControllerDelegate>
{
AVAudioRecorder *recorder;
NSTimer *levelTimer, *particleTimer;
double lowPassResults;
}


- (void)levelTimerCallback:(NSTimer *)timer;
@end
