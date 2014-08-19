//
//  AUMediaDownloadManager.h
//  AUMedia
//
//  Created by Piotr Bernad on 19.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AFURLSessionManager.h"
#import "AUItem.h"

@interface AUMediaDownloadManager : AFURLSessionManager

- (instancetype)sharedClient;
- (NSProgress *)downloadItem:(id<AUItem>)item;

@end
