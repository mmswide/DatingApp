//
//  CVImageCell.h
//  Pandemos
//
//  Created by Michael Sevy on 1/12/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewCellDelegate <NSObject>

-(void)previewCellDidReturnButtonAction:(BOOL)action;

@end
@interface PreviewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cvImage;
@property (weak, nonatomic) IBOutlet UIImageView *xImage;

@end


