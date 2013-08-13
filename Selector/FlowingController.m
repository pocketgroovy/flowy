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

@interface FlowingController ()
@property(nonatomic)CGSize screenSize;
@property(nonatomic)CGRect frame;
@property(nonatomic, strong)NSMutableArray *imageArray;
@property(nonatomic)UIImageView * selectedImage;
@property(nonatomic)CGRect newLocation;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property(nonatomic, strong)MailViewController * mvc;
@property(nonatomic)NSString * subject;
@property(nonatomic)NSArray * addresses;
@property(nonatomic)NSString * contents;
@property(nonatomic)BOOL isBlowed;
@property (nonatomic, strong)CCDirector * director;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *twitBarItem;

@end

@implementation FlowingController
@synthesize screenSize = _screenSize;
@synthesize frame = _frame;
@synthesize imageArray;
@synthesize selectedImage;
@synthesize picView;
@synthesize newLocation;
@synthesize mvc;
@synthesize subject;
@synthesize addresses;
@synthesize contents;
@synthesize isBlowed;
@synthesize twitBarItem;
@synthesize director;

#define PARTICLE_SIZE 40
#define NUMBER_OF_PARTICLE 50



- (void)viewDidLoad
{
    NSLog(@"%s in top", __FUNCTION__);


    [super viewDidLoad];
    
    
    
   //twitter button
    [twitBarItem setImage:[UIImage imageNamed:@"twitter-bird-light-bgs.png"]];
        
    
    
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
}


-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);

    [director end];
}

-(CGSize)screenSize
{
    CGSize screenSize = self.view.bounds.size;
    return screenSize;
}


-(void)setFrame:(CGRect)frame
{
    _frame.origin = frame.origin;
    _frame.size = frame.size;
}

//navigation bar height
#define NAVBARHEIGHT 67.00

- (IBAction)shot:(id)sender {
    AudioServicesPlaySystemSound(0x450);
    
    UIImage * snapShot;

    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad))
    {
       snapShot = [Snapshot takeAsUIImage];
    }
    else{
    snapShot = [Snapshot takeAsUIImage];
    }
    //save the snapshot image to the store
    [[BBFImageStore sharedStore]setImage:snapShot forKey:@"snapshot"];
    
}



-(IBAction)cancelSelection:(UIStoryboardSegue *)segue
{
    
}


- (IBAction)openMail:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        [self shot:sender];
        MFMailComposeViewController * mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;

        [mailer addAttachmentData:[Snapshot takeAsPNG] mimeType:@"image/png" fileName:@"flowyImage"];
        
        [self presentViewController:mailer animated:YES completion:NULL];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//COCOS DIRECTOR INIT
-(void)viewDidAppear:(BOOL)animated
{
    director = [CCDirector sharedDirector];
    
    if([director isViewLoaded] == NO)
    {
        
        CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow]bounds]
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
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
    NSLog(@"before runWithScene %s", __FUNCTION__);
    

    if(![director runningScene])
    {
        [director runWithScene: [EmitterLayer  scene]];
        [director pause];
        
    }
    NSLog(@"%s", __FUNCTION__);
}


//MAIL COMPOSE DELEGATE
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"sent!" message:@"Your email has been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert2 = [[UIAlertView alloc]initWithTitle:@"saved!" message:@"Your email has been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert3 = [[UIAlertView alloc]initWithTitle:@"failed!" message:@"Sending email has been failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert4 = [[UIAlertView alloc]initWithTitle:@"not sent!" message:@"Your email has not been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     UIAlertView * alert5 = [[UIAlertView alloc]initWithTitle:@"not sent!" message:@"cancelled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            [alert4 show];
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)tweetPhoto:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
    
    SLComposeViewController * tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [self shot:sender];

        [tweet addImage:[[BBFImageStore sharedStore]imageForKey:@"snapshot"]];
        [self presentViewController:tweet animated:YES completion:nil];
         }
  
}


- (IBAction)blowAgain:(id)sender {
    AudioServicesPlaySystemSound(1057);

    isBlowed = NO;
}


//SOUND LEVEL DETECTOR TO TRIGGER THE PARTICLES

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	
	if (lowPassResults > 0.1 && !isBlowed)
    {
        [director resume];
        isBlowed = YES;
        particleTimer = [NSTimer scheduledTimerWithTimeInterval: 10 target: self selector: @selector(particleTimerCallback:) userInfo: nil repeats: NO];
    }
    
    
}

-(void)particleTimerCallback:(NSTimer *)timer
{
    [director pause];
    NSLog(@"%s", __FUNCTION__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
