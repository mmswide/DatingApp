//
//  DragView.h
//  Pandemos
//
//  Created by Michael Sevy on 6/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "ImageScroll.h"

@protocol DragViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
@end

@interface DragView : UIView<UIScrollViewDelegate>

@property (weak) id <DragViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong)ImageScroll *imageScroll;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *schoolLabel;
@property (nonatomic,strong)UIView *nameAndSchoolView;

@property (nonatomic,strong)UIImageView *profileImageView;
@property (nonatomic,strong)UIImageView *profileImageView2;
@property (nonatomic,strong)UIImageView *profileImageView3;
@property (nonatomic,strong)UIImageView *profileImageView4;
@property (nonatomic,strong)UIImageView *profileImageView5;
@property (nonatomic,strong)UIImageView *profileImageView6;

@property (nonatomic,strong)UIView *v1;
@property (nonatomic,strong)UIView *v2;
@property (nonatomic,strong)UIView *v3;
@property (nonatomic,strong)UIView *v4;
@property (nonatomic,strong)UIView *v5;
@property (nonatomic,strong)UIView *v6;


-(void)leftClickAction;
-(void)rightClickAction;

@end