//
//  MerchantFormViewController.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "CategoryViewController.h"
#import "FormViewController.h"
#import "AllFields.h"

#define CELL_ID @"CellId"
#define SECTION_ID @"SectionId"
#define QK_ID @"qkid"
#define QK_OPTIONAL @"optional"
#define QK_MIN_LEN @"minlen"

#define IMPORT_SEGUE @"ImportSegue"

@interface CategoryViewController ()
{
	NSMutableArray *dataArray;
	NSMutableDictionary* dataDictionary;
	NSMutableArray *allowedCategories;
	NSMutableDictionary *formDictionary;
	AllFields *allFields;
	__weak IBOutlet UITableView *tv;
	UILabel *tvHeaderLbl;
}
@end

@implementation CategoryViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		dataDictionary = [[NSMutableDictionary alloc] init];
		allowedCategories = [[NSMutableArray alloc] init];
		dataArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationController.navigationBar.hidden = NO;
		self.navigationItem.hidesBackButton = NO;

	self.title = [formDictionary objectForKey:KEY_FORM_MNAME];
	CGRect rect = self.view.frame;
	rect.size.height = 40;
	 if (!tvHeaderLbl)
	 {
		 tvHeaderLbl= [[UILabel alloc] initWithFrame:rect];
	 }
	tv.tableHeaderView = tvHeaderLbl;
	tvHeaderLbl.text = [formDictionary objectForKey:KEY_FORM_NAME];
	tvHeaderLbl.textAlignment = NSTextAlignmentCenter;
	[tvHeaderLbl setFont:[UIFont fontWithName:@"System" size:16]];

}

- (void) loadFromDictionary:(NSDictionary *) formDict
{
	if (!allFields)
	{
		allFields = [AllFields getInstance];
	}
	NSArray *keyArray = [formDict objectForKey:KEY_FORM_KEYS];
	formDictionary = [[NSMutableDictionary alloc] initWithDictionary:formDict];
	for (id object in keyArray)
	{
		NSMutableDictionary *dictionary = object;
		NSString *fieldId = [dictionary objectForKey:QK_ID];
		NSDictionary *fieldDict = [allFields.fieldsDictionary objectForKey:fieldId];
		NSString *category = [fieldDict objectForKey:KEY_CATEGORY];
		NSMutableArray *categoryFldArray = [dataDictionary objectForKey:category];
		if (!categoryFldArray)
		{
			categoryFldArray = [[NSMutableArray alloc] init];
			[dataDictionary setObject:categoryFldArray forKey:category];
			[dataArray addObject:categoryFldArray];
			[allowedCategories addObject:category];
		}
		[categoryFldArray addObject:dictionary];
		[dictionary addEntriesFromDictionary:fieldDict];
	}
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SwitchTableCell  * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
	NSDictionary *dictionary = [[dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
	cell.label.text = [dictionary objectForKey:KEY_CATEGORY];
	cell.delegate = self;
	//cell.switchView.state = UIControlStateSelected;
	
	return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	SwitchTableCell *sectionView = [tableView dequeueReusableCellWithIdentifier:SECTION_ID];
	return sectionView;
}


#pragma mark - CustomCell delegate
- (void) stateChanged:(CustomCell *)c
{
	SwitchTableCell *cell = (SwitchTableCell *)c;
	NSIndexPath *indexPath = [tv indexPathForCell:cell];
	NSString *category = [[[dataArray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:KEY_CATEGORY];
	if (cell.switchView.on)
	{
		if (![allowedCategories containsObject:category])
		{
			[allowedCategories addObject:category];
		}
	}
	else
	{
		[allowedCategories removeObject:category];
	}
}

- (IBAction)importAction:(id)sender
{
	[self performSegueWithIdentifier:IMPORT_SEGUE sender:nil];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[formDictionary setObject:dataArray forKey:KEY_FORM_KEYS];
	if ([segue.identifier isEqualToString:IMPORT_SEGUE])
	{
		FormViewController *fvc = segue.destinationViewController;
		[fvc formDetails:formDictionary apprvedCategory:allowedCategories];
	}
}

@end
