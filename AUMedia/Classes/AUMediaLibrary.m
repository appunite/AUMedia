//
//  AUMediaLibrary.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMediaLibrary.h"

@interface AUMediaLibrary()

@end

@implementation AUMediaLibrary

- (instancetype)init {
    if (self = [super init]) {
        // Initialize Realm Database
        [RLMRealm defaultRealm];
        
    }
    
    return self;
}

- (NSData *)itemData:(AUMediaItem *)item {
    AUMediaItem *rlm_Item = [self _rlmObjectFromItem:item];
    
    if (!rlm_Item) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:rlm_Item.localPath];
    
    return data;
}

- (void)saveItem:(AUMediaItem *)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:item];
    [realm commitWriteTransaction];
    
}

- (void)removeItem:(AUMediaItem *)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMArray *array = [RLMObject objectsInRealm:realm withPredicate:[NSPredicate predicateWithFormat:@"uid == %@", item.uid]];
    
    for (RLMObject *object in array) {
        [realm deleteObject:object];
    }
    
}

#pragma mark - Private

- (AUMediaItem *)_rlmObjectFromItem:(AUMediaItem *)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMArray *array = [RLMObject objectsInRealm:realm withPredicate:[NSPredicate predicateWithFormat:@"uid == %@", item.uid]];
    if (array.count > 0) {
        return [array firstObject];
    }
    
    return nil;
}

@end
