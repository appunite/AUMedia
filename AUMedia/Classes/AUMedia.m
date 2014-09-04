//
//  AUMedia.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMedia.h"
#import "AUMediaItem.h"

NSString *const kAUMediaDownloadStartedNotification = @"kAUMediaDownloadStartedNotification";
NSString *const kAUMediaDownloadFinishedNotification = @"kAUMediaDownloadFinishedNotification";
NSString *const kAUMediaDownloadErrorNotification = @"kAUMediaDownloadErrorNotification";

@interface AUMedia()
@end

@implementation AUMedia

+ (AUMedia *)sharedInstance {
    static dispatch_once_t once;
    static AUMedia *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[AUMedia alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _mediaLibrary = [[AUMediaLibrary alloc] init];
        _downloadManager = [[AUMediaDownloadManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemStartDownloadingNotification:)
                                                     name:kAUMediaDownloadStartedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemStopedDownloadingNotification:)
                                                     name:kAUMediaDownloadFinishedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemDownloadErrorNotification:)
                                                     name:kAUMediaDownloadErrorNotification object:nil];
    }
    
    return self;
}

- (void)openMediaItem:(AUMediaItem *)item {
    [self openItemAsStream:item];
}

- (BOOL)downloadMediaItem:(AUMediaItem *)item {
    NSNumber *uid = @(item.uid);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMArray *array = [AUMediaItem objectsWithPredicate:pred];
    
    if (array.count > 0) {
        return NO;
    }
    
    [self.downloadManager downloadItem:item];
    
    return YES;
}

- (CGFloat)progressOfDownloadingItem:(AUMediaItem *)item {
    return 0;
}

#pragma mark - Private

- (void)openItem:(AUMediaItem *)item withLocalData:(NSData *)data {
    if ([item type] == AUAudioItemType) {
        [self openLocalAudio:item];
    }
}

- (void)openItemAsStream:(AUMediaItem *)item {
    if ([item type] == AUAudioItemType) {
        [self openStreamAudio:item];
    }
}

#pragma mark - Audio

- (void)openStreamAudio:(AUMediaItem *)item {
    NSAssert([item remotePath], @"Item remote path is nil");

    [[self audioPlayer] startStreamingRemoteAudioFromURL:[item remotePath] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
       
        if (self.audioProgressBlock) {
            self.audioProgressBlock(percentage, elapsedTime, timeRemaining, error, finished, item);
        }
        
    }];
}

- (void)openLocalAudio:(AUMediaItem *)item {
    [[self audioPlayer] startPlayingLocalFileWithName:[item localPath] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        if (self.audioProgressBlock) {
            self.audioProgressBlock(percentage, elapsedTime, timeRemaining, error, finished, item);
        }
    }];
}

- (AUAudioPlayer *)audioPlayer {
    return [AUAudioPlayer sharedManager];
}

#pragma mark - Download Manager Notifications

- (void)handleItemStartDownloadingNotification:(NSNotification *)notification {
}

- (void)handleItemStopedDownloadingNotification:(NSNotification *)notification {
}

- (void)handleItemDownloadErrorNotification:(NSNotification *)notification {
}

#pragma mark - Progress of downloading items

- (NSProgress *)progressForItem:(AUMediaItem *)item {
    NSURLSessionDownloadTask *downloadTask = [self.downloadManager downloadTaskForItem:item];
    
    if (!downloadTask) {
        return nil;
    }
    
    NSProgress *progress = [self.downloadManager downloadProgressForTask:downloadTask];
    return progress;
}


@end
