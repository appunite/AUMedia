//
//  AUMediaLibrary.h
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUItem.h"
#import <Realm/Realm.h>

@interface AUMediaLibrary : NSObject

- (NSData *)itemData:(id<AUItem>)item;

- (void)saveItem:(id<AUItem>)item;
- (void)removeItem:(id<AUItem>)item;

@end
