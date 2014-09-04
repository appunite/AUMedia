//
//  AUMediaLibrary.h
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "AUMediaItem.h"

@interface AUMediaLibrary : NSObject

- (NSData *)itemData:(AUMediaItem *)item;

- (void)saveItem:(AUMediaItem *)item;
- (void)removeItem:(AUMediaItem *)item;

@end
