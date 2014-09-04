//
//  AUMedia.h
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUMediaLibrary.h"
#import "AUAudioPlayer.h"
#import "AUMediaDownloadManager.h"

extern NSString *const kAUMediaDownloadStartedNotification;
extern NSString *const kAUMediaDownloadFinishedNotification;
extern NSString *const kAUMediaDownloadErrorNotification;

typedef void(^AUMediaAudioPlayerProgressBlock)(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished, AUMediaItem *item);
typedef void(^AUMediaDownloadProgressBlock)(int percentage, NSInteger downloadedBytes, NSInteger totalBytes);

@interface AUMedia : NSObject

+ (AUMedia *)sharedInstance;

@property (nonatomic, strong, readonly) AUMediaLibrary *mediaLibrary;
@property (nonatomic, strong, readonly) AUAudioPlayer *audioPlayer;
@property (nonatomic, strong, readonly) AUMediaDownloadManager *downloadManager;
@property (nonatomic, copy) AUMediaAudioPlayerProgressBlock audioProgressBlock;

@property (nonatomic, strong, readonly) NSMutableArray *downloadingItems;

- (NSProgress *)progressForItem:(AUMediaItem *)item;

- (void)openMediaItem:(AUMediaItem *)item;
- (BOOL)downloadMediaItem:(AUMediaItem *)item;


- (CGFloat)progressOfDownloadingItem:(AUMediaItem *)item;


@end
