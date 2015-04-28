//
//  XTFileUploader.m
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTFileUploader.h"

@implementation XTFileUploader : NSObject

- (XTFileUploader *) init
{
    if (self = [super init]) {
        data = [XTDataSingleton singleObj];
    }
    
    return self;
}

- (NSArray *) GetTourDirList
{
    NSString *path = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return directoryContent;
}

- (NSArray *) GetFileList
{
    NSArray *ListOfTourDir = [self GetTourDirList];
    NSString *pathTMP = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    NSString *path = [pathTMP stringByAppendingString:@"/"];
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [ListOfTourDir count]; i++) {
        NSString *currentFileTMP = [path stringByAppendingString:[ListOfTourDir objectAtIndex:i]];
        NSString *currentFile = [currentFileTMP stringByAppendingString:@"/"];
        
        NSArray *currentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentFile error:NULL];
        for (int k = 0; k < [currentDirectory count]; k++) {
            if ([[currentDirectory objectAtIndex:k] isEqualToString:@"images"]) {continue;}
            
            NSString *absFilePath = [currentFile stringByAppendingString:[currentDirectory objectAtIndex:k]];
            [fileList addObject:absFilePath];
        }
    }
    
    return fileList;
}

- (NSArray *) GetImageList
{
    NSArray *ListOfTourDir = [self GetTourDirList];
    NSString *pathTMP = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    NSString *path = [pathTMP stringByAppendingString:@"/"];
    NSMutableArray *fileList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [ListOfTourDir count]; i++) {
        NSString *currentFileTMP = [path stringByAppendingString:[ListOfTourDir objectAtIndex:i]];
        NSString *currentFile = [currentFileTMP stringByAppendingString:@"/images/"];
        
        NSArray *currentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentFile error:NULL];
        for (int k = 0; k < [currentDirectory count]; k++) {
            NSString *absFilePath = [currentFile stringByAppendingString:[currentDirectory objectAtIndex:k]];
            [fileList addObject:absFilePath];
        }
    }
    
    return fileList;
}

- (void) UploadGPXFiles
{
    NSMutableArray *GPXFiles = [data GetAllGPXFiles];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        [self UploadFile:[GPXFiles objectAtIndex:i]];
    }
}

- (void) UploadImages
{
    NSMutableArray *ImageFiles = [data GetAllImages];
    
    for (int i = 0; i < [ImageFiles count]; i++) {
        if ([[ImageFiles objectAtIndex:i] containsString:@"_original"]) {continue;}
        [self UploadFile:[ImageFiles objectAtIndex:i]];
    }
}

- (void) UploadImageInfo
{
    NSMutableArray *ImageInfoFiles = [data GetAllImageInfoFiles];
    
    for (int i = 0; i < [ImageInfoFiles count]; i++) {
        [self UploadFile:[ImageInfoFiles objectAtIndex:i]];
    }
}

- (void) UploadFile:(NSString *) filename
{
    NSURL *url = [NSURL URLWithString:@"http://www.xtour.ch/file_upload.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:filename, @"file", nil]];
    [request setPostValue:data.userID forKey:@"userID"];
    [request addFile:filename forKey:@"files"];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *filename = [[request userInfo] valueForKey:@"file"];
    NSString *response = [request responseString];
    
    if ([response isEqualToString:@"true"]) {
        NSLog(@"Upload of file %@ was successful", filename);
        
        [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
    }
    
    NSLog(@"The response text is:\n%@", response);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *filename = [[request userInfo] valueForKey:@"file"];
    NSError *error = [request error];
    
    NSLog(@"Upload of file %@ failed", filename);
    NSLog(@"Error:\n%@", error);
}

@end
