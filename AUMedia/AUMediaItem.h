//
//  AUMediaExampleItem.h
//  AUMedia
//
//  Created by Piotr Bernad on 19.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUMediaItem.h"
#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, AUItemType) {
    AUAudioItemType,
    AUVideoItemType,
    AUBookItemType,
    AUCollectionItemType,
};

@interface AUMediaItem : RLMObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;

- (NSString *)taskIdentifier;

@end
