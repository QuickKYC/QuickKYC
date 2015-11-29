//
//  MerchantFormViewController.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "QKViewController.h"
#import "SwitchTableCell.h"

@interface CategoryViewController : QKViewController<UITableViewDataSource, UITableViewDelegate, CustomCellDelegate>

- (void) loadFromDictionary:(NSDictionary *) formDict;

@end
