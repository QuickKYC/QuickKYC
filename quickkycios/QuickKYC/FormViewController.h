//
//  FormViewController.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import"QKViewController.h"
#import "TextTableCell.h"
#import "DropDownCell.h"
#import "TableView.h"

@interface FormViewController : QKViewController<UITableViewDataSource, UITableViewDelegate,TableViewDelegate, CustomCellDelegate>

- (void) formDetails:(NSDictionary *) fArray apprvedCategory:(NSArray *) cArray;

@end
