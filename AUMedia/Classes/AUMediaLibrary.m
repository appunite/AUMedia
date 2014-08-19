//
//  AUMediaLibrary.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMediaLibrary.h"

@interface AUMediaLibrary()

@property (nonatomic, strong) NSOperationQueue *writeInBackgroundQueue;

@end

@implementation AUMediaLibrary

- (instancetype)init {
    if (self = [super init]) {
        // Initialize Realm Database
        [RLMRealm defaultRealm];
        
        // Initialize background operation queue
        _writeInBackgroundQueue = [[NSOperationQueue alloc] init];
        
    }
    
    return self;
}

- (NSData *)itemData:(id<AUItem>)item {
    RLMObject<AUItem> *rlm_Item = [self _rlmObjectFromItem:item];
    
    if (!rlm_Item) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:rlm_Item.localPath];
    
    return data;
}

- (void)saveItem:(id<AUItem>)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [_writeInBackgroundQueue addOperationWithBlock:^{
        [realm beginWriteTransaction];
        [realm addObject:item];
        [realm commitWriteTransaction];
    }];
    
}

- (void)removeItem:(id<AUItem>)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [_writeInBackgroundQueue addOperationWithBlock:^{
        
        RLMArray *array = [RLMObject objectsInRealm:realm
                                      withPredicate:[NSPredicate predicateWithFormat:@"uid == %@", item.uid]];
        
        for (RLMObject *object in array) {
            [realm deleteObject:object];
        }
        
    }];
}

#pragma mark - Private

- (RLMObject<AUItem> *)_rlmObjectFromItem:(id<AUItem>)item {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMArray *array = [RLMObject objectsInRealm:realm withPredicate:[NSPredicate predicateWithFormat:@"uid == %@", item.uid]];
    if (array.count > 0) {
        return [array firstObject];
    }
    
    return nil;
}

@end
