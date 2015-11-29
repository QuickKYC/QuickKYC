//
//  Profiles.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profiles : NSObject

@property (nonatomic, readonly)	NSMutableDictionary * profileDictionary;

+ (Profiles *) getInstance;
@end
