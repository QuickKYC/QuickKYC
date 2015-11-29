//
//  FormViewController.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "FormViewController.h"
#import "SwitchTableCell.h"
#import "KLCPopup.h"
#import "Profiles.h"
#import "Docs.h"
#import "AppDelegate.h"

#define TEXT_CELL_ID @"TextCellId"
#define DROPDOWN_CELL_ID @"DropDownCellId"
#define IMAGE_CELL_ID @"ImageCellId"
#define SECTION_ID @"SectionId"

@interface FormViewController ()
{
	NSMutableArray *formArray;
	NSDictionary *formDictionary;
	NSMutableArray *categoryArray;
	__weak IBOutlet UITableView *tv;
	UIAlertController *alertController;
	UIDatePicker *picker;
	NSDictionary *dictionary;
	KLCPopup *popup;
	NSString *user;
	NSDictionary *profileFieldDict;
	NSDateFormatter *plistDateFormatter;
	NSDateFormatter *displayDateFormatter;
	TableView *popupTv;
	UILabel *tvHeaderLbl;
}

@end

@implementation FormViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		formArray = [[NSMutableArray alloc] init];
		categoryArray = [[NSMutableArray alloc] init];
		user = @"Sophia";
		plistDateFormatter = [[NSDateFormatter alloc] init];
		[plistDateFormatter setDateFormat:@"ddMMyyyy"];
		
		displayDateFormatter = [[NSDateFormatter alloc] init];
		[displayDateFormatter setDateFormat:@"dd-MMM-yyyy"];
	}
	return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	//added for scrollview
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	CGRect rect = self.view.frame;
	rect.size.height = 40;
	self.title = [formDictionary objectForKey:KEY_FORM_MNAME];
	
	if (!tvHeaderLbl)
	{
		tvHeaderLbl= [[UILabel alloc] initWithFrame:rect];
	}
	tv.tableHeaderView = tvHeaderLbl;
	tvHeaderLbl.text = [formDictionary objectForKey:KEY_FORM_NAME];
	tvHeaderLbl.textAlignment = NSTextAlignmentCenter;
	[tvHeaderLbl setFont:[UIFont fontWithName:@"System" size:16]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) formDetails:(NSDictionary *) dict apprvedCategory:(NSArray *) cArray
{
	[formArray removeAllObjects];
	[categoryArray removeAllObjects];
	formDictionary = [[NSDictionary alloc] initWithDictionary:dict];
	[formArray addObjectsFromArray:[formDictionary objectForKey:KEY_FORM_KEYS]];
	[categoryArray addObjectsFromArray:cArray];
	NSLog(@"formDetails end");
}

- (void) viewWillAppear:(BOOL)animated
{
	profileFieldDict = [[Profiles getInstance].profileDictionary objectForKey:user];
	
	for (NSArray *array in formArray)
	{
		if (array.count == 0)
			continue;
		
		
		for (NSMutableDictionary * dict in array)
		{
			NSString *fId = [dict objectForKey:KEY_ID];
			NSString *category = [dict objectForKey:KEY_CATEGORY];
			NSString *value = [profileFieldDict objectForKey:fId];
			if (value && [categoryArray containsObject:category])
			{
				[dict setValue:value forKey:KEY_VALUE];
			}
			else
			{
				[dict removeObjectForKey:KEY_VALUE];
			}
		}
	}
	NSLog(@"viewWillAppear end");
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return formArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ((NSArray *)[formArray objectAtIndex:section]).count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dict = [[formArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *dataType = [dict objectForKey:KEY_DATATYPE];
	NSString *value = [dict objectForKey:KEY_VALUE];
	if ([dataType isEqualToString:DT_DATE])
	{
		DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:DROPDOWN_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		if (value)
		{
			NSDate *date = [plistDateFormatter dateFromString:value];
			NSString *dateStr = [displayDateFormatter stringFromDate:date];
			[cell.button setTitle:dateStr forState:UIControlStateNormal];
		}
		else
		{
			[cell.button setTitle:@"" forState:UIControlStateNormal];
			
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_ENUM])
	{
		DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:DROPDOWN_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		if (value)
		{
			[cell.button setTitle:value forState:UIControlStateNormal];
		}
		else
		{
			[cell.button setTitle:@"" forState:UIControlStateNormal];
			
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_TEXT] || [dataType isEqualToString:DT_TEXTAREA] || [dataType isEqualToString:DT_EMAIL])
	{
		TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		cell.textField.keyboardType = UIKeyboardTypeDefault;
		[cell.textField reloadInputViews];
		if (value)
		{
			cell.textField.text = value;
		}
		else
		{
			cell.textField.text = @"";
			cell.textField.placeholder = [dict objectForKey:KEY_NAME];
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_NUMBER] || [dataType isEqualToString:DT_AMOUNT])
	{
		TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
		[cell.textField reloadInputViews];
		if (value)
		{
			cell.textField.text = value;
		}
		else
		{
			cell.textField.text = @"";
			cell.textField.placeholder = [dict objectForKey:KEY_NAME];
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_Phone])
	{
		TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		cell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
		[cell.textField reloadInputViews];
		if (value)
		{
			cell.textField.text = value;
		}
		else
		{
			cell.textField.text = @"";
			cell.textField.placeholder = [dict objectForKey:KEY_NAME];
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_NUMBER])
	{
		TextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		[cell.textField reloadInputViews];
		if (value)
		{
			cell.textField.text = value;
		}
		else
		{
			cell.textField.text = @"";
			cell.textField.placeholder = [dict objectForKey:KEY_NAME];
		}
		cell.delegate = self;
		return cell;
	}
	else if ([dataType isEqualToString:DT_DOCUMENT])
	{
		ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELL_ID];
		cell.label.text = [dict objectForKey:KEY_NAME];
		
		if (value)
		{
			cell.imageNameLabel.text = value;
			UIImage *image = [UIImage imageNamed:value];
			[cell.button setImage:image forState:UIControlStateNormal];
		}
		else
		{
			cell.imageNameLabel.text = @"";
			[cell.button setImage:nil forState:UIControlStateNormal];
		}
		cell.delegate = self;
		return cell;
	}
	else
	{
		UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
		NSLog(@"DataType: %@", dataType);
		return cell;
	}
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	SwitchTableCell *sectionView = [tableView dequeueReusableCellWithIdentifier:SECTION_ID];
	sectionView.label.text = [[[formArray objectAtIndex:section] objectAtIndex:0] objectForKey:KEY_CATEGORY];
	return sectionView;
}

#pragma mark - Notification handlers
- (void)keyboardWillShow:(NSNotification*)notification
{
	
	CGRect keyboardBounds;
	NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
	[aValue getValue:&keyboardBounds];
	CGRect aRect = self.view.frame;
	aRect.size.height -= keyboardBounds.size.height;
	CGRect contentRect = tv.frame;
	
	if (!CGRectContainsRect(aRect, contentRect))
	{
		CGFloat diff = keyboardBounds.size.height - (self.view.frame.size.height - (tv.frame.origin.y + tv.frame.size.height));
		contentRect.size.height -= diff;
		tv.frame = contentRect;
	}
	else
	{
		NSLog(@"else");
	}
}

- (void)keyboardWillHide:(NSNotification*)notification{
	CGRect keyboardBounds;
	NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
	[aValue getValue:&keyboardBounds];
	CGRect aRect = self.view.frame;
	tv.frame = aRect;
}

#pragma mark - cell Delegate
- (void) buttonPressed:(CustomCell *)cell;
{
	NSIndexPath *indexPath = [tv indexPathForCell:cell];
	NSDictionary *dict = [[formArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	if ([[dict objectForKey:KEY_DATATYPE] isEqualToString:DT_DATE])
	{
		[self showDatePicker:dict];
	}
	else
	{
		[self showTablePopup:dict];
	}
}

- (void) textChanged:(CustomCell *)cell
{
	NSIndexPath *indexPath = [tv indexPathForCell:cell];
	NSMutableDictionary *dict = [[formArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	[dict setObject:((TextTableCell *)cell).textField.text forKey:KEY_VALUE];
}



- (void)showDatePicker:(NSDictionary *)dict
{
	if (!alertController)
	{
		alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		picker = [[UIDatePicker alloc] init];
		[picker setDatePickerMode:UIDatePickerModeDate];
		[alertController.view addSubview:picker];
		[alertController addAction:({
			UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				NSDate *date = picker.date;
				NSString *dateStr = [plistDateFormatter stringFromDate:date];
				[dict setValue:dateStr forKey:KEY_VALUE];
				NSLog(@"%@",picker.date);
				[tv reloadData];
			}];
			action;
		})];
		
		[alertController addAction:({
			UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
			}];
			action;
		})];
	}
	[self presentViewController:alertController  animated:YES completion:nil];
}

- (void) showTablePopup:(NSDictionary *) dict
{
	CGRect popupRect = self.view.frame;
	popupRect.origin.x = 0;
	popupRect.origin.y = 0;
	
	//80% of screen
	popupRect.size.width = popupRect.size.width * 0.85;
	
	//60% of screen
	popupRect.size.height = popupRect.size.height * 0.55;
	
	popupTv =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TableView"];
	popupTv.view.frame = popupRect;
	[popupTv loadUsingTable:[dict objectForKey:KEY_OPTIONS] title:[dict objectForKey:KEY_NAME]];
	popupTv.delegate  = self;
	popup = [KLCPopup popupWithContentView:popupTv.view];
	popup.dictionary = dict;
	KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
	[popup showWithLayout:layout];
	dictionary = dict;
	//[tableView.tableView reloadData];
}

#pragma mark - table popup
- (void) selectedAtIndex:(int)index
{
	[popup dismiss:YES];
	
	[popup.dictionary setValue:[[dictionary objectForKey:KEY_OPTIONS] objectAtIndex:index] forKey:KEY_VALUE];
	[tv reloadData];
}

- (IBAction)saveAction:(id)sender
{
	NSArray *visibleCells = [tv visibleCells];
	
	for (CustomCell * cell in visibleCells)
	{
		if ([cell isMemberOfClass:[TextTableCell class]])
		{
			[((TextTableCell *)cell).textField resignFirstResponder];
		}
	}
	
	NSMutableArray *fieldsArray = [[NSMutableArray alloc] init];
	NSMutableArray *docFieldArray = [[NSMutableArray alloc] init];
	for (NSArray *array in formArray)
	{
		
		for (NSMutableDictionary * dict in array)
		{
			NSString *fId = [dict objectForKey:KEY_ID];
			NSString *name = [dict objectForKey:KEY_NAME];
			BOOL optional = [[dict objectForKey:KEY_FORM_OPTIONAL] boolValue];
			NSString *value = [dict objectForKey:KEY_VALUE];
			NSString *dataType = [dict objectForKey:KEY_DATATYPE];
			int minLen = [[dict objectForKey:KEY_FORM_MINLEN] intValue];
			if (optional && !value)
			{
				continue;
			}
			else if (value && value.length >= minLen)
			{
				if ([dataType isEqualToString:@"DOC"])
				{
					Docs *doc = [Docs getInstance];
					
					NSString *mid = [[doc.usersDocDictionary objectForKey:user] objectForKey:value];
					
					NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
					[dataDict setObject:[dict objectForKey:KEY_FORM_KEY_ID] forKey:KEY_FORM_KEY_ID];
					UIImage *image = [UIImage imageNamed:value];
					
					NSData* data = UIImageJPEGRepresentation(image, 1.0f);
					NSData *encodedData = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
					NSString* strEncoded =[NSString stringWithUTF8String:[encodedData bytes]];
					NSLog(@"str::%@::", strEncoded);
					[dataDict setObject:strEncoded forKey:KEY_FORM_DATA];
					if (mid)
					{
						[dataDict setObject:mid forKey:KEY_FORM_MID];
					}
					[docFieldArray addObject:dataDict];
				}
				else
				{
					NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
					[dataDict setObject:fId forKey:KEY_FORM_KEY_ID];
					[dataDict setObject:value forKey:KEY_VALUE];
					[fieldsArray addObject:dataDict];
				}
			}
			else
			{
				/*NSString *msg;
				 if (!value || value.length == 0)
				 {
					msg = [NSString stringWithFormat:@"%@ is empty", name];
				 }
				 else
				 {
					msg = [NSString stringWithFormat:@"%@ should have more then %d characters", name, minLen];
				 }
				 UIAlertController * msgAlertVC = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
				 [msgAlertVC addAction:({
					UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
				 {
				 
				 }];
					action;
				 })];
				 [self presentViewController:msgAlertVC animated:YES completion:nil];*/
			}
		}
	}
	
	NSString *url = [NSString stringWithFormat:@"%@%@",[formDictionary objectForKey:KEY_FORM_URL], @"/merchant/submitform"];
	//NSString *url = @"http://192.168.137.154/QuickKYC/quickkyc_merchant/merchant/submitform";
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[formDictionary objectForKey:KEY_FORM_NAME] forKey:KEY_FORM_NAME];
	[dict setObject:[formDictionary objectForKey:KEY_FORM_MNAME] forKey:KEY_FORM_MNAME];
	[dict setObject:[formDictionary objectForKey:KEY_FORM_ID] forKey:KEY_FORM_ID];
	[dict setObject:fieldsArray	forKey:KEY_FORM_KEYS];
	
	if (docFieldArray.count > 0)
	{
		[dict setObject:docFieldArray forKey:KEY_FORM_DOCS];
	}
	
	[Request getDataFromUrl:url postData:dict withObject:self];
}

-(void) response:(NSData *)data attachment:(NSObject *)attachment
{
	NSDictionary *dict = [Request getDictionaryFromData:data];
	NSLog(@"dictionary : %@", dict);
	UIAlertAction *action;
	UIAlertAction *cancelAction;
	NSString *msg = @"";
	
	if ([[dict objectForKey:@"status"] isEqualToString:@"success"])
	{
		msg = @"Form Submitted Successfully";
		action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
				  {
					[self performSegueWithIdentifier:@"ScanViewSegue" sender:nil];  
				  }];
	}
	else if ([[dict objectForKey:@"status"] isEqualToString:@"failure"])
	{
		msg = @"Can not submit form, Try Again";
		msg = @"Form Submitted Successfully";
		action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
				  {
					 // [self.navigationController popToRootViewControllerAnimated:YES];
					  [self performSegueWithIdentifier:@"ScanViewSegue" sender:nil];
					  
				  }];
		cancelAction= [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
					   {
						   
					   }];
	}
	else
	{
		msg = [NSString stringWithFormat:@"Can not submit form, Try Again\n%@.", [dict objectForKey:@"status"]];
		action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
				  {
					  [self saveAction:nil];
				  }];
		cancelAction= [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
					   {
						   
					   }];
	}
	
	UIAlertController * msgAlertVC = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
	[msgAlertVC addAction:action];
	if (cancelAction)
		[msgAlertVC addAction:cancelAction];
	[self presentViewController:msgAlertVC animated:YES completion:nil];
	
	
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
