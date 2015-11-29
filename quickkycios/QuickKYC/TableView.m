//
//  TableView.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "TableView.h"
#import "CustomCell.h"

#define CELL_ID @"CellId"
#define SECTION_ID @"SectionId"

@implementation TableView

@synthesize delegate;

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
	cell.label.text = dataArray[indexPath.row];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	CustomCell *sectionView = [tableView dequeueReusableCellWithIdentifier:SECTION_ID];
	sectionView.label.text = title;
	return sectionView;
}

- (void) loadUsingTable:(NSArray *) array title:(NSString *) t
{
	dataArray = array;
	title = t;
	//[self.tableView reloadData];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[delegate selectedAtIndex:(int)indexPath.row];
}

@end
