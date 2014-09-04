//
//  AUMediaDownloadManager.m
//  AUMedia
//
//  Created by Piotr Bernad on 19.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMediaDownloadManager.h"
#import "AUMedia.h"

static NSString *kAUMediaDownloadManagerIdentifier = @"kAUMediaDownloadManagerIdentifier";

@implementation AUMediaDownloadManager

- (instancetype)init {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kAUMediaDownloadManagerIdentifier];
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        
    }
    
    return self;
}

- (NSProgress *)downloadItem:(AUMediaItem *)item {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[item remotePath]]];
    
    NSProgress *progress = [[NSProgress alloc] init];
    
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        [item setLocalPath:[targetPath absoluteString]];
        
        [[[AUMedia sharedInstance] mediaLibrary] saveItem:item];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAUMediaDownloadFinishedNotification object:nil];
        
        return targetPath;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        
    }];
    
    [downloadTask setTaskDescription:item.taskIdentifier];
    
    [downloadTask resume];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAUMediaDownloadStartedNotification object:nil];
    
    return progress;
}

- (void)saveItem:(AUMediaItem *)item withLocalPath:(NSString *)filePath {
    
}

- (NSURLSessionDownloadTask *)downloadTaskForItem:(AUMediaItem *)item {
    for (NSURLSessionDownloadTask *task in self.downloadTasks) {
        if ([task.taskDescription isEqualToString:item.taskIdentifier]) {
            return task;
        }
    }
    
    return nil;
}

@end
