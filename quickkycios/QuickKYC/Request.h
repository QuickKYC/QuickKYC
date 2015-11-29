//
//  Request.h
//  AsyncReq
//
//  Created by Brijesh Singh on 28/09/15.
//  Copyright (c) 2015 teligenzTechSolutions. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol RequestProtocol <NSObject>

- (void) response:(NSData *) data attachment:(NSObject *) attachment;

@end

@interface Request : NSObject

+ (void) getDataFromUrl:(NSString *)url postData:(NSDictionary *)dictionary withObject:(id<RequestProtocol>)delegate attachment:(NSObject *) attachment;
+ (void) getDataFromUrl:(NSString *)url postData:(NSDictionary *)dictionary withObject:(id<RequestProtocol>)delegate;
+ (NSMutableDictionary *) getDictionaryFromData:(NSData *)data;

@end
