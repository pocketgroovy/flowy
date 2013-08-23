//
//  BBFViewController.m
//  blowByFlow
//
//  Created by Yoshihisa Miyamoto on 4/7/13.
//  Copyright (c) 2013 Yoshi Miyamoto. All rights reserved.
//

#import "BBFViewController.h"
#import "BBFImageStore.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "MailViewController.h"

@interface BBFViewController ()
@property (strong, nonatomic)UIPopoverController * imagePickerPopover;
@end

@implementation BBFViewController
@synthesize key;
@synthesize imageView;
@synthesize barButtonOK;
@synthesize photo;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    photo = [[BBFImageStore sharedStore]imageForKey:@"defaultImage"];
    if(!photo)
    {
        photo = [UIImage imageNamed:@"camera2.png"];
    }
    imageView.image = photo;
    

}


- (IBAction)takePhoto:(UIBarButtonItem *)sender
{
    AudioServicesPlaySystemSound(0x450);
    
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}
- (IBAction)addPhoto:(UIBarButtonItem *)sender
{
    AudioServicesPlaySystemSound(0x450);
    
    [self presentImagePicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum sender:sender];
}

-(void)presentImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIBarButtonItem *)sender
{
    if(!self.imagePickerPopover &&[UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeImage])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.sourceType =sourceType;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            picker.delegate = self;
            //for iPad
            if((sourceType != UIImagePickerControllerSourceTypeCamera) &&(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad))
            {
                self.imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:picker];
                [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.imagePickerPopover.delegate =self;
            }
            else{
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
        
    }
}


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image)
    {

        //save the photo a user selected to the store
        
        [[BBFImageStore sharedStore]setImage:image forKey:@"mySelectedPhoto"];

        //[self.imageView setImage:image];
        [imageView setImage:image];
    }
    
    if(self.imagePickerPopover)
    {
        [[BBFImageStore sharedStore]setImage:image forKey:@"mySelectedPhoto"];
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - For iPhone to return to the main controller
- (IBAction)returnToMain:(id)sender {
    
    for (UIViewController * vc in [self.navigationController viewControllers]) {
        if([vc isKindOfClass:[MainViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - For iOS5 and older orientation in iPAD
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    NSLog(@"%s", __FUNCTION__);

    return YES;
}
-(BOOL)shouldAutorotate
{    NSLog(@"%s", __FUNCTION__);

    return NO;
}
#pragma mark - For iOS6 bug
-(NSUInteger)supportedInterfaceOrientations
{    NSLog(@"%s", __FUNCTION__);

    return UIInterfaceOrientationMaskLandscape;
}


#pragma mark 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
