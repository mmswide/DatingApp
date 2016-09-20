//
//  UICollectionView+Pandemos.m
//  Pandemos
//
//  Created by Michael Sevy on 5/18/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UICollectionView+Pandemos.h"
#import "UIColor+Pandemos.h"

@implementation UICollectionView (Pandemos)

+(void)setupBorder:(UICollectionView *)collectionView
{
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.layer.borderWidth = 2;
    collectionView.layer.borderColor = [UIColor mikeGray].CGColor;
    collectionView.layer.cornerRadius = 7;
}
@end
