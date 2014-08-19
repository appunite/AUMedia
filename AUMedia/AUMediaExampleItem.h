//
//  AUMediaExampleItem.h
//  AUMedia
//
//  Created by Piotr Bernad on 19.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUItem.h"

@interface AUMediaExampleItem : NSObject <AUItem>

@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) AUItemType type;
@property (nonatomic, strong) NSString *remotePath;
@end
