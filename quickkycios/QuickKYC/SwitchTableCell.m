//
//  SwitchTableCell.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "SwitchTableCell.h"

@implementation SwitchTableCell
@synthesize switchView;

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)switchedValueChanged:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(stateChanged:)])
	{
		[self.delegate stateChanged:self];
	}
}

@end
