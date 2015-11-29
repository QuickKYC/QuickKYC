
//
//  Docs.m
//  QuickKYC
//
//  Created by macdev on 29/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "Docs.h"

static Docs *instance;
@implementation Docs

+ (Docs *) getInstance;
{
	if (!instance)
	{
		instance = [[Docs alloc] init];
	}
	return instance;
}

- (id) init
{
	self = [super self];
	if (self)
	{
		_usersDocDictionary = [[NSMutableDictionary alloc] init];
		[self loadData];
	}
	return self;
}

-(void) loadData
{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Docs.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: path])
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Docs" ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath: path error:&error];
	}
	_usersDocDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
}
@end
