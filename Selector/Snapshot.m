//
//  Snapshot.m
//  DemoView
//
//  Created by YOSHIHISA MIYAMOTO on 5/8/13.
//  Copyright (c) 2013 YOSHIHISA MIYAMOTO. All rights reserved.
//

#import "Snapshot.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Snapshot

@synthesize imageData;
@synthesize image;
-(void)snap
{
//     NSString * imagePath = [self imagePathForKey:@"s2.png"];

    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO,0.0);
    else
    {
        UIGraphicsBeginImageContext(self.window.bounds.size);
     
    }
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *imageSource = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    //the entire screen image
    CGImageRef ref = imageSource.CGImage;
    
    CGRect imageRect = CGRectMake(0, 65, self.window.bounds.size.width, 370);
    
    //trim the screen image into the rect
    CGImageRef imageRef = CGImageCreateWithImageInRect(ref, imageRect);
    
    image = [UIImage imageWithCGImage:imageRef];
    
    //convert the UIImage to PNG
    imageData = UIImagePNGRepresentation(image);
    
    
//       [imageData writeToFile:imagePath atomically:YES];

}

-(void)snapIpad
{
    //     NSString * imagePath = [self imagePathForKey:@"s2.png"];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO,0.0);
    else
    {
        UIGraphicsBeginImageContext(self.window.bounds.size);
        
    }
    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageSource = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //the entire screen image
    CGImageRef ref = imageSource.CGImage;

    
    CGRect imageRect = CGRectMake(50, 350, self.window.bounds.size.width - 130, 900);
    
    //trim the screen image into the rect
    CGImageRef imageRef = CGImageCreateWithImageInRect(ref, imageRect);
    
    image = [UIImage imageWithCGImage:imageRef];
    
  
    
    //convert the UIImage to PNG
    imageData = UIImagePNGRepresentation(image);
    
    
    //       [imageData writeToFile:imagePath atomically:YES];
    
}


@end
