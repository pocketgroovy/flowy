//
//  SelectorAppDelegate.h
//  Selector
//
//  Created by Yoshihisa Miyamoto on 4/23/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SelectorAppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic)NSMutableArray * productList;


@end
