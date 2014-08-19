//
//  AUMedia.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMedia.h"

@interface AUMedia()
@property (nonatomic, strong) NSMutableDictionary *downloadInfoCache;
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
        _downloadInfoCache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)openMediaItem:(id<AUItem>)item {
    [self openItemAsStream:item];
}

- (void)downloadMediaItem:(id<AUItem>)item {
    NSProgress *progress = [_downloadManager downloadItem:item];
    [_downloadInfoCache setObject:progress forKey:@(item.uid)];
    
}

- (CGFloat)progressOfDownloadingItem:(id<AUItem>)item {
    return 0;
}

#pragma mark - Private

- (void)openItem:(id<AUItem>)item withLocalData:(NSData *)data {
    if ([item type] == AUAudioItemType) {
        [self openLocalAudio:item];
    }
}

- (void)openItemAsStream:(id<AUItem>)item {
    if ([item type] == AUAudioItemType) {
        [self openStreamAudio:item];
    }
}

#pragma mark - Audio

- (void)openStreamAudio:(id<AUItem>)item {
    NSAssert([item remotePath], @"Item remote path is nil");

    [[self audioPlayer] startStreamingRemoteAudioFromURL:[item remotePath] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
       
        if (self.audioProgressBlock) {
            self.audioProgressBlock(percentage, elapsedTime, timeRemaining, error, finished, item);
        }
        
    }];
}

- (void)openLocalAudio:(id<AUItem>)item {
    [[self audioPlayer] startPlayingLocalFileWithName:[item localPath] andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        if (self.audioProgressBlock) {
            self.audioProgressBlock(percentage, elapsedTime, timeRemaining, error, finished, item);
        }
    }];
}

- (AUAudioPlayer *)audioPlayer {
    return [AUAudioPlayer sharedManager];
}

@end
