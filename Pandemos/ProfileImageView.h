//
//  ProfileImageView.h
//  Pandemos
//
//  Created by Michael Sevy on 6/3/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileImageViewDelegate <NSObject>

@end

@interface ProfileImageView : UIView<UIScrollViewDelegate>

@property (weak) id <ProfileImageViewDelegate> delegate;

@property (nonatomic, strong)UIScrollView *imageScroll;

@property (nonatomic, strong)UIView *descriptionView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *schoolLabel;

@property (nonatomic, strong)UIView *tallDescriptionView;
@property (nonatomic,strong)UILabel *tallNameLabel;
@property (nonatomic,strong)UILabel *tallSchoolLabel;
@property (nonatomic,strong)UILabel *tallWorkLabel;
@property (nonatomic,strong)UILabel *tallAboutMeLabel;

@property (nonatomic,strong)UIImageView* profileImageView;
@property (nonatomic,strong)UIImageView* profileImageView2;
@property (nonatomic,strong)UIImageView* profileImageView3;
@property (nonatomic,strong)UIImageView* profileImageView4;
@property (nonatomic,strong)UIImageView* profileImageView5;
@property (nonatomic,strong)UIImageView* profileImageView6;

@property (nonatomic,strong)UIView *v1;
@property (nonatomic,strong)UIView *v2;
@property (nonatomic,strong)UIView *v3;
@property (nonatomic,strong)UIView *v4;
@property (nonatomic,strong)UIView *v5;
@property (nonatomic,strong)UIView *v6;
@property unsigned long imageCount;
@end
