//
//  DropDownCell.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "DropDownCell.h"

@implementation DropDownCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonAction:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(buttonPressed:)])
	{
		[self.delegate buttonPressed:self];
	}
}

@end
