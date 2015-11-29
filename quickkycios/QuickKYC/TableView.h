//
//  TableView.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TableViewDelegate <NSObject>

- (void) selectedAtIndex:(int)index;

@end

@interface TableView : UIViewController
{
	IBOutlet __weak UITableView *tv;
	NSArray *dataArray;
	NSString *title;
}

@property (nonatomic, weak) id<TableViewDelegate> delegate;

- (void) loadUsingTable:(NSArray *) array title:(NSString *) title;

@end
