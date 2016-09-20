//
//  MNCChatMessageCell.h
//  Pandemos
//
//  Created by Michael Sevy on 6/19/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNCChatMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *myMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *outgoingTimestampFooter;
@property (weak, nonatomic) IBOutlet UILabel *incomingTimestampFooter;
@property (weak, nonatomic) IBOutlet UIImageView *yourImage;
@property (weak, nonatomic) IBOutlet UIImageView *recipientImage;

//+ (CGFloat)defaultFontSize;
//+(CGSize)sizeForMessage:(LYRMessage *)message withWidth:(CGFloat)width;
@end
