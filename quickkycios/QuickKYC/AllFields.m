//
//  AllFields.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "AllFields.h"
#import "Constants.h"

static AllFields *instance;

@implementation AllFields

+ (AllFields *) getInstance;
{
	if (!instance)
	{
		instance = [[AllFields alloc] init];
	}
	return instance;
}

- (id) init
{
	self = [super self];
	if (self)
	{
		_fieldsDictionary = [[NSMutableDictionary alloc] init];
		[self loadData];
	}
	return self;
}

-(void) loadData
{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AllFields.plist"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath: path])
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"AllFields" ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath: path error:&error];
		
	}
	_fieldsArray = [NSArray arrayWithContentsOfFile:path];
	[self prepareDictionary];
	
}

- (void) prepareDictionary
{
	for (id object in _fieldsArray)
	{
		NSDictionary *dictionary = object;
		NSString *keyId = [object objectForKey:KEY_ID];
		[_fieldsDictionary setObject:dictionary forKey:keyId];
	}
}

@end
