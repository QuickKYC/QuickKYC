//
//  Profiles.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "Profiles.h"
#import "Constants.h"

static Profiles *instance;

@implementation Profiles

+ (Profiles *) getInstance;
{
	if (!instance)
	{
		instance = [[Profiles alloc] init];
	}
	return instance;
}

- (id) init
{
	self = [super self];
	if (self)
	{
		_profileDictionary = [[NSMutableDictionary alloc] init];
		[self loadData];
	}
	return self;
}

-(void) loadData
{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Profiles.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath: path])
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Profiles" ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath: path error:&error];
		
	}
	_profileDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

@end
