//
//  TextTableCell.m
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import "TextTableCell.h"

@implementation TextTableCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)textChanged:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(textChanged:)])
	{
		[self.delegate textChanged:self];
		
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
