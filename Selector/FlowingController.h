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
#import "MPInterstitialAdController.h"

@interface FlowingController : UIViewController <MFMailComposeViewControllerDelegate, CCDirectorDelegate, UINavigationControllerDelegate, MPInterstitialAdControllerDelegate, UIAlertViewDelegate>
{
NSTimer *levelTimer, *particleTimer;
double lowPassResults;
}
@property (nonatomic, strong)MPInterstitialAdController *interstitialAd;
@property (nonatomic, strong)AVAudioRecorder *recorder;

- (void)levelTimerCallback:(NSTimer *)timer;
@end
