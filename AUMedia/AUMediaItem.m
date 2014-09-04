//
//  AUMediaExampleItem.m
//  AUMedia
//
//  Created by Piotr Bernad on 19.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "AUMediaItem.h"

@implementation AUMediaItem

- (NSString *)taskIdentifier {
    return [NSString stringWithFormat:@"%ld", self.uid];
}

@end
