//
//  Docs.h
//  QuickKYC
//
//  Created by macdev on 29/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Docs : NSObject

@property (nonatomic, readonly)	NSMutableDictionary * usersDocDictionary;

+ (Docs *) getInstance;

@end
