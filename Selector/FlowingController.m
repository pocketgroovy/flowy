//
//  FlowingController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/17/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "FlowingController.h"
#import "MailViewController.h"
#import "BBFImageStore.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EmitterLayer.h"
#import "Snapshot.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@interface FlowingController ()
@property(nonatomic)BOOL isBlowed;
@property (nonatomic, strong)CCDirector * director;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *twitBarItem;

@end

@implementation FlowingController
@synthesize isBlowed;
@synthesize twitBarItem;
@synthesize director;



- (void)viewDidLoad
{
    [super viewDidLoad];
        
   //twitter button
    [twitBarItem setImage:[UIImage imageNamed:@"twitter-bird-light-bgs.png"]];
        
    director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        
        CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow]bounds]
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:YES  //this needs to be YES for iOS 6 and newer to place the scene in the snapshot
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        director.view = glView;
        
        [director setAnimationInterval:1.0f/60.0f];
        [director enableRetinaDisplay:YES];
    }
    
    director.delegate = self;
    
    [self addChildViewController:director];
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    [director didMoveToParentViewController:self];    
    
    //run the scene and pause the emitter for a user to blow
    if(![director runningScene])
    {
        [director runWithScene: [EmitterLayer  scene]];
        [director pause];
    }
    
    
    //SET UP RECORDER FOR SOUND LEVEL DETECTION
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
    
	NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
		levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
	} else
		NSLog(@"No recorder");
    NSLog(@"%f width, %f height", [director winSize].width,[director winSize].height);

}

#pragma mark - end the scene if the view is unloaded
-(void)viewWillDisappear:(BOOL)animated
{
    [director end];
    director = nil;
    [particleTimer invalidate];
}



#pragma mark - navigation bar height
#define NAVBARHEIGHT 67.00

#pragma mark - SNAPSHOT

- (void)shot:(id)sender {
    AudioServicesPlaySystemSound(0x450);
    
    UIImage * snapShot;

    CCScene * scene = [[CCDirector sharedDirector]runningScene];
    CCNode * node = [scene.children objectAtIndex:0];
    
    snapShot = [Snapshot takeAsUIImage:node];

    //save the snapshot image to the store
    [[BBFImageStore sharedStore]setImage:snapShot forKey:@"snapshot"];
    
}




#pragma mark - OPEN MAIL COMPOSER
- (IBAction)openMail:(id)sender{
    CCScene * scene = [[CCDirector sharedDirector]runningScene];
    CCNode * node = [scene.children objectAtIndex:0];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;

        [mailer addAttachmentData:[Snapshot takeAsPNG:node] mimeType:@"image/png" fileName:@"flowyImage"];
        
        [self presentViewController:mailer animated:YES completion:NULL];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - MAIL COMPOSE DELEGATE
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"SENT!" message:@"Your email has been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert2 = [[UIAlertView alloc]initWithTitle:@"SAVED!" message:@"Your email has been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert3 = [[UIAlertView alloc]initWithTitle:@"FAILED!" message:@"Sending email has been failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert5 = [[UIAlertView alloc]initWithTitle:@"NOT SENT!" message:@"cancelled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    switch (result) {
        case MFMailComposeResultCancelled:
            [alert5 show];
            break;
        case MFMailComposeResultSaved:
            [alert2 show];
            break;
        case MFMailComposeResultSent:
            [alert show];
            break;
        case MFMailComposeResultFailed:
            [alert3 show];
            break;
        default:
            [alert5 show];
            break;
    }
    
    
    //recover the selected picture after the email composer returns
    if(!director)
    {
        director = [CCDirector sharedDirector];
        if([director isViewLoaded] == NO)
        {
            
            CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow]bounds]
                                           pixelFormat:kEAGLColorFormatRGB565
                                           depthFormat:0
                                    preserveBackbuffer:YES  //this needs to be YES for iOS 6 and newer to be taken for the snapshot
                                            sharegroup:nil
                                         multiSampling:NO
                                       numberOfSamples:0];
            
            director.view = glView;
            
            [director setAnimationInterval:1.0f/60.0f];
            [director enableRetinaDisplay:YES];            
        }
        director.delegate = self;
                
        [self addChildViewController:director];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
        [director didMoveToParentViewController:self];
        
        if(![director runningScene])
        {
            [director runWithScene: [EmitterLayer  scene]];
            [director pause];
        }
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Twitter
- (IBAction)tweetPhoto:(id)sender {
    
  
    if(NSClassFromString(@"SLComposeViewController")) // check to see Social framework is available
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
        
            SLComposeViewController * tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [self shot:sender];
        
            [tweet addImage:[[BBFImageStore sharedStore]imageForKey:@"snapshot"]];
            [self presentViewController:tweet animated:YES completion:nil];
        }
 
    
    }
    else if(NSClassFromString(@"TWTweetComposeViewController"))  //for iOS5.1 and earlier
    {
        if(![TWTweetComposeViewController canSendTweet])
        {
            NSLog(@"Can't tweet");
            twitBarItem.enabled = NO;
        }
    
        TWTweetComposeViewController * tweetVC = [[TWTweetComposeViewController alloc]init];
        [self shot:sender];

        [tweetVC addImage:[[BBFImageStore sharedStore]imageForKey:@"snapshot"]];

        [tweetVC setCompletionHandler:^(TWTweetComposeViewControllerResult result){
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    NSLog(@"Tweet cancelled");

                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    NSLog(@"Tweet done");
                    
                default:
                    break;
            }
            
            [self dismissModalViewControllerAnimated:YES];
        }];
        
        [self presentModalViewController:tweetVC animated:YES];
    
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"Your device doesn't support the Twitter" delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alert show];
    }
  
}

#pragma mark - Try blow
- (IBAction)blowAgain:(id)sender {
   AudioServicesPlaySystemSound(1057);

    isBlowed = NO;
}


#pragma mark SOUND LEVEL DETECTOR TO TRIGGER THE PARTICLES

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	
	if (lowPassResults > 0.3 && !isBlowed)
    {
        [director resume];
        isBlowed = YES;
        particleTimer = [NSTimer scheduledTimerWithTimeInterval: 10 target: self selector: @selector(particleTimerCallback:) userInfo: nil repeats: NO];
    }
    
    
}

#pragma mark Particle Pause

-(void)particleTimerCallback:(NSTimer *)timer
{
    [director pause];
}

#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - For iOS6
-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - For iOS6 bug
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
