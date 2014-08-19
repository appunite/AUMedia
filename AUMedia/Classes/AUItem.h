//
//  AUItem.h
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AUItemType) {
    AUAudioItemType,
    AUVideoItemType,
    AUBookItemType,
    AUCollectionItemType,
};

@protocol AUItem <NSObject>

@required

- (NSUInteger)uid;
- (NSString *)remotePath;
- (AUItemType)type;
- (NSString *)localPath;
- (void)setLocalPath:(NSString *)localPath;

@optional

- (NSArray *)collectionItems;

@end
