//
//  Request.m
//  AsyncReq
//
//  Created by Brijesh Singh on 28/09/15.
//  Copyright (c) 2015 teligenzTechSolutions. All rights reserved.
//

#import "Request.h"

@implementation Request

+ (void)  getDataFromUrl:(NSString *)urlStr postData:(NSDictionary *)dictionary withObject:(id<RequestProtocol>)delegate attachment:(NSObject *)attachment
{
		if ([NSJSONSerialization isValidJSONObject:dictionary])//validate it
		{
			NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
			[urlRequest setURL:[[NSURL alloc] initWithString:urlStr]];
			[urlRequest setHTTPMethod:@"POST"];
			[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
			[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			
			NSError *error;
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
			NSString *postParameter = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
			[urlRequest setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[postParameter length]] forHTTPHeaderField:@"Content-Length"];
			[urlRequest setHTTPBody:[[NSString stringWithFormat:@"data=%@", postParameter] dataUsingEncoding:NSUTF8StringEncoding]];
			
			[NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
			{
				if(error!=nil)
				{
					NSLog(@"%s Error is %@", __FUNCTION__, error);
				}
				[delegate response:data attachment:attachment];
			}];
		}
}

+ (void)  getDataFromUrl:(NSString *) url postData:(NSDictionary *)dictionary withObject:(id<RequestProtocol>)delegate
{
	[Request  getDataFromUrl:url postData:dictionary withObject:delegate attachment:nil];
}

+ (NSMutableDictionary *) getDictionaryFromData:(NSData *) data
{
	NSError *error = [[NSError alloc] init];
	NSMutableDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
	return resultsDictionary;

}

@end
