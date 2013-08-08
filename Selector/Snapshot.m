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


+(UIImage*)takeAsUIImage
{
    CCDirector* director = [CCDirector sharedDirector];
    CGSize size = [director winSize];
    //Create buffer for pixels
    GLuint bufferLength = size.width * size.height * 4;
    GLubyte* buffer = (GLubyte*)malloc(bufferLength);
    //Read Pixels from OpenGL
    glReadPixels(0, 0, size.width, size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    //Make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    //Configure image
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * size.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef iref = CGImageCreate(size.width, size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    
    uint32_t*pixels = (uint32_t*)malloc(bufferLength);
    CGContextRef context = CGBitmapContextCreate(pixels, [director winSize].width, [director winSize].height, 8, [director winSize].width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
 
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), iref);
    UIImage *outputImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    
    
    
    //Dealloc
    CGDataProviderRelease(provider);
    CGImageRelease(iref);
    CGContextRelease(context);
    free(buffer);
    free(pixels);
    
    return outputImage;
}

+(NSData *)takeAsPNG
{
    NSData * ouputImage = UIImagePNGRepresentation([Snapshot takeAsUIImage]);
    
    return ouputImage;
}



-(void)snapIpadInViewWidth:(CGFloat )width andHeight:(CGFloat)height withNavBar:(CGFloat)navHeight
{
    //     NSString * imagePath = [self imagePathForKey:@"s2.png"];
    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        UIGraphicsBeginImageContextWithOptions(self.window.bounds.size, NO,0.0);
//    else
//    {
//        UIGraphicsBeginImageContext(self.window.bounds.size);
//        
//    }
//    [self.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageSource = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //the entire screen image
//    CGImageRef ref = imageSource.CGImage;
//
//    
//    CGRect imageRect = CGRectMake(navHeight, 0, width , height);
//    
//    //trim the screen image into the rect
//    CGImageRef imageRef = CGImageCreateWithImageInRect(ref, imageRect);
//    
//    
//    image = [UIImage imageWithCGImage:imageRef];
//    
//  
//    
//    //convert the UIImage to PNG
//    imageData = UIImagePNGRepresentation(image);
    
    
    //       [imageData writeToFile:imagePath atomically:YES];
    
}


@end
