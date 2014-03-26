//
//  SGMenuCell.m
//  Saga
//
//  Created by Raphaël Korach on 25/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGMenuCell.h"

@implementation SGMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{    
    if (highlighted) {
        self.label.textColor = [UIColor redColor];
    } else {
        self.label.textColor = [UIColor whiteColor];
    }
}

@end
