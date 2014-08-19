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

typedef void(^AUMediaAudioPlayerProgressBlock)(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished, id<AUItem> item);
typedef void(^AUMediaDownloadProgressBlock)(int percentage, NSInteger downloadedBytes, NSInteger totalBytes);

@interface AUMedia : NSObject

+ (AUMedia *)sharedInstance;

@property (nonatomic, strong, readonly) AUMediaLibrary *mediaLibrary;
@property (nonatomic, strong, readonly) AUAudioPlayer *audioPlayer;
@property (nonatomic, strong, readonly) AUMediaDownloadManager *downloadManager;
@property (nonatomic, copy) AUMediaAudioPlayerProgressBlock audioProgressBlock;

- (void)openMediaItem:(id<AUItem>)item;
- (void)downloadMediaItem:(id<AUItem>)item;

- (NSArray *)downloadingItems;
- (NSArray *)downloadedItems;

- (CGFloat)progressOfDownloadingItem:(id<AUItem>)item;

@end
