//
//  PhotoCell.m
//  InstagramReaderEx
//
//  Created by AlleyOops on 2015/6/19.
//  Copyright (c) 2015年 AlleyOops. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) prepareForReuse {
    [self.mainPhotoView setImage:[UIImage imageNamed:@"defaultLoading"]];
}

@end
