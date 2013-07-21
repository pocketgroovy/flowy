//
//  FlowingController.m
//  Selector
//
//  Created by Yoshihisa Miyamoto on 5/17/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "FlowingController.h"
#import "Snapshot.h"
#import "MailViewController.h"
#import "BBFImageStore.h"
#import <AudioToolbox/AudioToolbox.h>



@interface FlowingController ()
@property(nonatomic)CGSize screenSize;
@property(nonatomic)CGRect frame;
@property(nonatomic)NSMutableArray *imageArray;
@property(nonatomic)UIImageView * selectedImage;
@property(nonatomic)CGRect newLocation;
@property(nonatomic)Snapshot *snapShot;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property(nonatomic)MailViewController * mvc;
@property(nonatomic)NSString * subject;
@property(nonatomic)NSArray * addresses;
@property(nonatomic)NSString * contents;
@property(nonatomic)BOOL isBlowed;
@end

@implementation FlowingController
@synthesize screenSize = _screenSize;
@synthesize frame = _frame;
@synthesize imageArray;
@synthesize selectedImage;
@synthesize picView;
@synthesize newLocation;
@synthesize snapShot;
@synthesize mvc;
@synthesize subject;
@synthesize addresses;
@synthesize contents;
@synthesize isBlowed;
@synthesize twitBarItem;

#define PARTICLE_SIZE 40
#define NUMBER_OF_PARTICLE 50



- (void)viewDidLoad
{
    int i;
    self.imageArray= [[NSMutableArray alloc]init];;
    [super viewDidLoad];
    
    //twitter button
    [twitBarItem setImage:[UIImage imageNamed:@"twitter-bird-light-bgs.png"]];
    
    CGRect picViewFrame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    [picView setFrame:picViewFrame];

    //get back the picture selected earlier from the store and add it to the views
    UIImage * picSelected = [[BBFImageStore sharedStore]imageForKey:@"mySelectedPhoto"];
    if(picSelected)
    {
    [picView setImage:picSelected];
    [self.view addSubview:picView];
    }
    
    
    //get back the image selected earlier from the store and add them to the view
    for(i = 0; i < NUMBER_OF_PARTICLE ; i++)
    {
        selectedImage =[[UIImageView alloc]initWithImage:[[BBFImageStore sharedStore]imageForKey:@"myColoredShape"]];
        selectedImage.frame = CGRectMake(arc4random()% (int)self.screenSize.width/4 + (self.screenSize.width/3), arc4random()% (int)self.screenSize.height/20 + (self.screenSize.height/20 * 15), PARTICLE_SIZE, PARTICLE_SIZE);

        [self.imageArray addObject:selectedImage];
        [self.view addSubview:[self.imageArray objectAtIndex:i ]];
        
    }
    
    snapShot = [[Snapshot alloc]init];
    [self.view addSubview:snapShot];
    
    
    // audio detection
    
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
		levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
	} else
		NSLog(@"No recorder");
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
    
  

    
    float photoFrameWidth = self.photoView.bounds.size.height - 5;
    float photoFrameHeight = self.photoView.bounds.size.width;

    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad))
    {
        [snapShot snapIpadInViewWidth:photoFrameWidth andHeight:photoFrameHeight withNavBar:NAVBARHEIGHT];
    }
    else{
    [snapShot snap];
    }
    //save the snapshot image to the store
    [[BBFImageStore sharedStore]setImage:snapShot.image forKey:@"snapshot"];
}



-(IBAction)cancelSelection:(UIStoryboardSegue *)segue
{
    
}


- (IBAction)openMail:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        [self shot:sender];
        MFMailComposeViewController * mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;

        [mailer addAttachmentData:[snapShot imageData] mimeType:@"image/png" fileName:@"flowyImage"];
        
        [self presentViewController:mailer animated:YES completion:NULL];
    }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


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

#define MOVE_DURATION 5.0

-(void)setRandomLocationForView:(UIView *)view atDistance:(CGSize)distance
{
 
if(distance.height != 0 && distance.width != 0)
{
    newLocation.origin.x= arc4random()%((int)distance.width+1) + view.frame.origin.x;
    newLocation.origin.y=arc4random()%((int)distance.height+1) + view.frame.origin.y;
    
    //set new location within the screen
    if(newLocation.origin.x > self.screenSize.width)
    {
        newLocation.origin.x -= self.screenSize.width;
    }
    if(newLocation.origin.y > self.screenSize.height)
    {
        newLocation.origin.y -= self.screenSize.height;
        
    }
    
    view.center = CGPointMake(newLocation.origin.x, newLocation.origin.y);
}
    else
        view.center = CGPointMake(view.frame.origin.x, view.frame.origin.y);
}

- (IBAction)blowAgain:(id)sender {
    AudioServicesPlaySystemSound(1057);

    isBlowed = NO;
}


- (IBAction)moveLoop:(id)sender {
    for(int i = 0; i < [imageArray count]; i++)
    {
        [self move:[imageArray objectAtIndex:i]];
    }
}

-(void)move:(UIImageView *) image
{
    
    CGSize __block newDistance;
    CGPoint __block orgPoint;
    
    
    CGAffineTransform transform = image.transform;
    
    [UIView animateWithDuration:MOVE_DURATION/5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        image.transform = CGAffineTransformRotate(transform, 2*M_PI/3);
        orgPoint.x = image.frame.origin.x;
        orgPoint.y = image.frame.origin.y;
        
        newLocation.size = self.view.frame.size;
        
        [self setRandomLocationForView:image atDistance:newLocation.size];
        
        //location
        newDistance.width = orgPoint.x - newLocation.origin.x;
        newDistance.height = orgPoint.y - newLocation.origin.y;
        
        if(newDistance.width < 0)
            newDistance.width *= -1;
        if(newDistance.height < 0)
            newDistance.height *= -1;
        
    } completion:^(BOOL finished){
        if(finished)
        {
            [UIView animateWithDuration:MOVE_DURATION/5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                image.transform = CGAffineTransformRotate(transform, -2*M_PI/3);
                orgPoint.x = image.frame.origin.x;
                orgPoint.y = image.frame.origin.y;
                
                [self setRandomLocationForView:image atDistance:newDistance];
                
                
                //location
                newDistance.width = orgPoint.x - newLocation.origin.x;
                newDistance.height = orgPoint.y - newLocation.origin.y;
                
                if(newDistance.width < 0)
                    newDistance.width *= -1;
                if(newDistance.height < 0)
                    newDistance.height *= -1;
                
                
                
            }
             
                             completion:^(BOOL finished){
                                 if(finished){
                                     [UIView animateWithDuration:MOVE_DURATION/5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                         image.transform = CGAffineTransformRotate(transform, 0);
                                         orgPoint.x = image.frame.origin.x;
                                         orgPoint.y = image.frame.origin.y;
                                         
                                         [self setRandomLocationForView:image atDistance:newDistance];
                                         
                                         //location
                                         newDistance.width = orgPoint.x - newLocation.origin.x;
                                         newDistance.height = orgPoint.y - newLocation.origin.y;
                                         
                                         if(newDistance.width < 0)
                                             newDistance.width *= -1;
                                         if(newDistance.height < 0)
                                             newDistance.height *= -1;
                                         
                                         
                                     }
                                                      completion:^(BOOL finished){
                                                          if(finished){
                                                              [UIView animateWithDuration:MOVE_DURATION/5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                                                  image.transform = CGAffineTransformRotate(transform, 2*M_PI/3);
                                                                  
                                                                  orgPoint.x = image.frame.origin.x;
                                                                  orgPoint.y = image.frame.origin.y;
                                                                  [self setRandomLocationForView:image atDistance:newDistance];
                                                                  
                                                                  
                                                                  //location
                                                                  newDistance.width = orgPoint.x - newLocation.origin.x;
                                                                  newDistance.height = orgPoint.y - newLocation.origin.y;
                                                                  
                                                                  if(newDistance.width < 0)
                                                                      newDistance.width *= -1;
                                                                  if(newDistance.height < 0)
                                                                      newDistance.height *= -1;
                                                                  
                                                                  
                                                              }completion:^(BOOL finished){
                                                                  if(finished){
                                                                      [UIView animateWithDuration:MOVE_DURATION/5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                                          image.transform = CGAffineTransformRotate(transform, -2*M_PI/3);
                                                                          orgPoint.x = image.frame.origin.x;
                                                                          orgPoint.y = image.frame.origin.y;
                                                                          
                                                                          [self setRandomLocationForView:image atDistance:newDistance];
 
                                                                          
                                                                      }
                                                                    completion:nil];
                                                                  }
                                                              }];
                                                          }
                                                      }];
                                 }
                             }];
        }
    }];
    
    
}
//}









- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
	
	if (lowPassResults > 0.65 && !isBlowed)
    {
        [self moveLoop:self];
        isBlowed = YES;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
