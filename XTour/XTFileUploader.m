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
    
    for (int i = 0; i < [directoryContent count]; i++) {
        NSLog(@"%@", [directoryContent objectAtIndex:i]);
    }
    
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
            NSLog(@"%@", [fileList objectAtIndex:k]);
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
            NSLog(@"%@", [fileList objectAtIndex:k]);
        }
    }
    
    return fileList;
}

- (void) UploadGPXFiles
{
    NSArray *GPXFiles = [self GetFileList];
    
    NSURL *url = [NSURL URLWithString:@"http://www.xtour.ch/fileUpload.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setPostValue:data.userID forKey:@"userID"];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        [request addFile:[GPXFiles objectAtIndex:i] forKey:@"files[]"];
    }
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@", response);
    }
}

@end
