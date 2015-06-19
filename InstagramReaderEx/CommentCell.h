//
//  CommentCell.h
//  InstagramReaderEx
//
//  Created by AlleyOops on 2015/6/19.
//  Copyright (c) 2015年 AlleyOops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
