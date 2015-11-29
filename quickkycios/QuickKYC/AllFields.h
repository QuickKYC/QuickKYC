//
//  AllFields.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllFields : NSObject

@property (nonatomic, readonly)	NSArray * fieldsArray;
@property (nonatomic, readonly)	NSMutableDictionary * fieldsDictionary;

+ (AllFields *) getInstance;
@end
