//
//  AlbumCustomCell.h
//  Pandemos
//
//  Created by Michael Sevy on 1/30/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *albumNames;
@property (weak, nonatomic) IBOutlet UILabel *albumCountLabel;

@end
