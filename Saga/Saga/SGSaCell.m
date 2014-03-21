//
//  SGSaCell.m
//  Saga
//
//  Created by Raphaël Korach on 21/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGSaCell.h"

@interface SGSaCell()

@end

@implementation SGSaCell

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

@end
