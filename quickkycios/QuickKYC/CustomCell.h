//
//  CustomCell.h
//  QuickKYC
//
//  Created by macdev on 28/11/15.
//  Copyright © 2015 Teligenz Tech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCell;

@protocol CustomCellDelegate <NSObject>

@optional
- (void) stateChanged:(CustomCell *)cell;

- (void) buttonPressed:(CustomCell *)cell;


@end

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) id<CustomCellDelegate> delegate;

@end
