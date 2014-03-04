//
//  XTFileUploader.h
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "XTDataSingleton.h"

@interface XTFileUploader : NSObject
{
    XTDataSingleton *data;
}

- (NSArray *) GetTourDirList;
- (NSArray *) GetFileList;
- (NSArray *) GetImageList;
- (void) UploadGPXFiles;

@end
