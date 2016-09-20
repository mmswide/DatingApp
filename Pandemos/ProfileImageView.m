//
//  ProfileImageView.m
//  Pandemos
//
//  Created by Michael Sevy on 6/3/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "ProfileImageView.h"
#import "AppConstants.h"
#import "UIColor+Pandemos.h"

@implementation ProfileImageView

static float CARD_HEIGHT;
static float CARD_WIDTH;

@synthesize delegate;

@synthesize imageScroll;
@synthesize schoolLabel;
@synthesize nameLabel;

@synthesize tallDescriptionView;
@synthesize tallNameLabel;
@synthesize tallSchoolLabel;
@synthesize tallWorkLabel;
@synthesize tallAboutMeLabel;

@synthesize descriptionView;
@synthesize profileImageView;
@synthesize profileImageView2;
@synthesize profileImageView3;
@synthesize profileImageView4;
@synthesize profileImageView5;
@synthesize profileImageView6;

@synthesize v1;
@synthesize v2;
@synthesize v3;
@synthesize v4;
@synthesize v5;
@synthesize v6;
@synthesize imageCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];

        if (IS_IPHONE4)
        {
            CARD_HEIGHT = 400;
            CARD_WIDTH = 280;
        }
        else if (IS_IPHONE5)
        {
            CARD_WIDTH = 280;
            CARD_HEIGHT = 500;
        }
        else if (IS_IPHONE6)
        {
            CARD_WIDTH = 376;
            CARD_HEIGHT = 675;
        }
        else if (IS_IPHONE6PLUS)
        {
            CARD_WIDTH = 390;
            CARD_HEIGHT = 680;
        }

        imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:imageScroll];
        imageScroll.delegate = self;
        imageScroll.pagingEnabled = YES;
        imageScroll.scrollEnabled = YES;
        imageScroll.clipsToBounds = YES;
        imageScroll.userInteractionEnabled = YES;
        imageScroll.scrollsToTop = NO;
        //imageScroll.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3);//multiplied by pro

        profileImageView = [UIImageView new];
        [imageScroll addSubview:profileImageView];
        profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
        profileImageView.backgroundColor = [UIColor blackColor];
        [self addProfileImage1Constraints];

        profileImageView2 = [UIImageView new];
        [imageScroll addSubview:profileImageView2];
        profileImageView2.translatesAutoresizingMaskIntoConstraints = NO;
        profileImageView2.backgroundColor = [UIColor redColor];
        [self addProfileImage2Constraints];

        profileImageView3 = [UIImageView new];
        [imageScroll addSubview:profileImageView3];
        profileImageView3.translatesAutoresizingMaskIntoConstraints = NO;
        profileImageView3.backgroundColor = [UIColor greenColor];
        [self addProfileImage3Constraints];

        profileImageView4 = [UIImageView new];
        [imageScroll addSubview:profileImageView4];
        profileImageView4.translatesAutoresizingMaskIntoConstraints = NO;
        [self addProfileImage4Constraints];

        profileImageView5 = [UIImageView new];
        [imageScroll addSubview:profileImageView5];
        profileImageView5.translatesAutoresizingMaskIntoConstraints = NO;
        [self addProfileImage5Constraints];

        profileImageView6 = [UIImageView new];
        [imageScroll addSubview:profileImageView6];
        profileImageView6.translatesAutoresizingMaskIntoConstraints = NO;
        [self addProfileImage6Constraints];

        //View Indicator for scrolling profileImages
        imageCount = 0;

        v1 = [UIView new];
        [self addSubview:v1];
        [self setForViewIndicator:v1];
        [self addView1Constraints];
        v1.backgroundColor = [UIColor whiteColor];

        v2 = [UIView new];
        [self addSubview:v2];
        [self setForViewIndicator:v2];
        [self addView2Constraints];

        v3 = [UIView new];
        [self addSubview:v3];
        [self setForViewIndicator:v3];
        [self addView3Constraints];

        v4 = [UIView new];
        [self addSubview:v4];
        [self setForViewIndicator:v4];
        [self addView4Constraints];

        v5 = [UIView new];
        [self addSubview:v5];
        [self setForViewIndicator:v5];
        [self addView5Constraints];

        v6 = [UIView new];
        [self addSubview:v6];
        [self setForViewIndicator:v6];
        [self addView6Constraints];

        descriptionView = [UIView new];
        [self addSubview:descriptionView];
        descriptionView.translatesAutoresizingMaskIntoConstraints = NO;
        descriptionView.layer.cornerRadius = 8;
        descriptionView.backgroundColor = [UIColor grayColor];
        [self addDescriptionViewConstraints];

        nameLabel = [UILabel new];
        [descriptionView addSubview:nameLabel];
        nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [nameLabel setFont:[UIFont fontWithName:@"GeezaPro" size:18.0]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addNameLabelConstraints];

        schoolLabel = [UILabel new];
        [descriptionView addSubview:schoolLabel];
        schoolLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [schoolLabel setFont:[UIFont fontWithName:@"GeezaPro" size:16.0]];
        schoolLabel.lineBreakMode = NSLineBreakByWordWrapping;
        schoolLabel.numberOfLines = 0;
        [schoolLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSchoolLabelConstraints];



//        tallDescriptionView = [UIView new];
//        [self addSubview:tallDescriptionView];
//        tallDescriptionView.translatesAutoresizingMaskIntoConstraints = NO;
//        tallDescriptionView.layer.cornerRadius = 8;
//        tallDescriptionView.backgroundColor = [UIColor lightGrayColor];
//        [self addTallDescriptionViewConstraints];
//
//        tallNameLabel = [UILabel new];
//        [tallDescriptionView addSubview:tallNameLabel];
//        tallNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        [tallNameLabel setFont:[UIFont fontWithName:@"GeezaPro" size:18.0]];
//        [tallNameLabel setTextAlignment:NSTextAlignmentCenter];
//        [self addTallNameLabelConstraints];
    }

    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

-(void)setForViewIndicator:(UIView*)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 6;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor yellowGreen].CGColor;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = CARD_HEIGHT;
    float fractionalPage = scrollView.contentOffset.y / pageHeight;
    NSInteger page = ceilf(fractionalPage);

    switch (page)
    {
        case 0:
            [v2 setBackgroundColor:nil];
            [v1 setBackgroundColor:[UIColor whiteColor]];
            [v3 setBackgroundColor:nil];
            [v4 setBackgroundColor:nil];
            [v5 setBackgroundColor:nil];
            [v6 setBackgroundColor:nil];
            break;
        case 1:
            [v1 setBackgroundColor:nil];
            [v2 setBackgroundColor:[UIColor whiteColor]];
            [v3 setBackgroundColor:nil];
            [v4 setBackgroundColor:nil];
            [v5 setBackgroundColor:nil];
            [v6 setBackgroundColor:nil];
            break;
        case 2:
            [v1 setBackgroundColor:nil];
            [v3 setBackgroundColor:[UIColor whiteColor]];
            [v2 setBackgroundColor:nil];
            [v4 setBackgroundColor:nil];
            [v5 setBackgroundColor:nil];
            [v6 setBackgroundColor:nil];
            break;
        case 3:
            [v1 setBackgroundColor:nil];
            [v4 setBackgroundColor:[UIColor whiteColor]];
            [v2 setBackgroundColor:nil];
            [v3 setBackgroundColor:nil];
            [v5 setBackgroundColor:nil];
            [v6 setBackgroundColor:nil];
            break;
        case 4:
            [v1 setBackgroundColor:nil];
            [v5 setBackgroundColor:[UIColor whiteColor]];
            [v2 setBackgroundColor:nil];
            [v4 setBackgroundColor:nil];
            [v3 setBackgroundColor:nil];
            [v6 setBackgroundColor:nil];
            break;
        case 5:
            [v1 setBackgroundColor:nil];
            [v6 setBackgroundColor:[UIColor whiteColor]];
            [v2 setBackgroundColor:nil];
            [v4 setBackgroundColor:nil];
            [v5 setBackgroundColor:nil];
            [v3 setBackgroundColor:nil];
            break;
        default:
            break;
    }
}

#pragma mark -- HELPERS
#pragma mark -- DESCRIPTION CONSTRAINTS
//need to find a way to activate the tall description view
//-(void)addTallDescriptionViewConstraints
//{
//    NSDictionary *viewsDictionary = @{@"tallView":tallDescriptionView, @"lowestViewIndicator":v6};
//    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lowestViewIndicator]-8-[tallView]"
//                                                                    options:0
//                                                                    metrics:nil
//                                                                      views:viewsDictionary];
//
//    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tallView]-15-|"
//                                                                        options:0
//                                                                        metrics:nil
//                                                                          views:viewsDictionary];
//
//    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[tallView]-32-|"
//                                                                        options:0
//                                                                        metrics:nil
//                                                                          views:viewsDictionary];
//    [self addConstraints:constraint_H];
//    [self addConstraints:constraint_POS_H];
//    //[self addConstraints:constraint_POS_V];
//}
//
//-(void)addTallNameLabelConstraints
//{
//    NSDictionary *informationDict = @{@"tallName":tallNameLabel};
//
//    NSArray *infoCon_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tallName(20)]"
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:informationDict];
//
//    NSArray *infoCon_PosH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[tallName]-5-|"
//                                                                    options:0
//                                                                    metrics:nil
//                                                                      views:informationDict];
//
//    NSArray *infoCon_PosV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[tallName]"
//                                                                    options:0
//                                                                    metrics:nil
//                                                                      views:informationDict];
//    [tallNameLabel addConstraints:infoCon_H];
//    [tallDescriptionView addConstraints:infoCon_PosH];
//    [tallDescriptionView addConstraints:infoCon_PosV];
//}




-(void)addDescriptionViewConstraints
{
    NSDictionary *viewsDictionary = @{@"matchView":descriptionView};
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[matchView(70)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];

    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[matchView]-15-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];

    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[matchView]-32-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [descriptionView addConstraints:constraint_H];
    [self addConstraints:constraint_POS_H];
    [self addConstraints:constraint_POS_V];
}

-(void)addNameLabelConstraints
{
    NSDictionary *informationDict = @{@"name":nameLabel};

    NSArray *infoCon_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[name(20)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:informationDict];

    NSArray *infoCon_PosH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[name]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:informationDict];

    NSArray *infoCon_PosV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[name]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:informationDict];
    [nameLabel addConstraints:infoCon_H];
    [descriptionView addConstraints:infoCon_PosH];
    [descriptionView addConstraints:infoCon_PosV];
}

-(void)addSchoolLabelConstraints
{
    NSDictionary *informationDict = @{@"school": schoolLabel, @"name":nameLabel};
    NSArray *infoCon_PosH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[school]-8-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:informationDict];

    NSArray *infoCon_PosV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[school]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:informationDict];
    [descriptionView addConstraints:infoCon_PosH];
    [descriptionView addConstraints:infoCon_PosV];
}

#pragma mark -- PROFILE IMAGE CONSTRAINTS
-(void)addProfileImage1Constraints
{
    NSDictionary *imageDict = @{@"imageView":profileImageView};
    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView addConstraints:imgConstraint_POS_H];
    [profileImageView addConstraints:imgConstraint_POS_V];
}


-(void)addProfileImage2Constraints
{
    NSDictionary *imageDict = @{@"imageView2":profileImageView2};
    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView2]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView2(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView2(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                           views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView2 addConstraints:imgConstraint_POS_H];
    [profileImageView2 addConstraints:imgConstraint_POS_V];
}

-(void)addProfileImage3Constraints
{
    NSDictionary *imageDict = @{@"imageView3":profileImageView3};
    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView3]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView3(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView3(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                             views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView3 addConstraints:imgConstraint_POS_H];
    [profileImageView3 addConstraints:imgConstraint_POS_V];
}

-(void)addProfileImage4Constraints
{
    NSDictionary *imageDict = @{@"imageView4":profileImageView4};
    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView4]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView4(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView4(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                             views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView4 addConstraints:imgConstraint_POS_H];
    [profileImageView4 addConstraints:imgConstraint_POS_V];
}

-(void)addProfileImage5Constraints
{
    NSDictionary *imageDict = @{@"imageView5":profileImageView5};

    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView5]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView5(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView5(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                             views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView5 addConstraints:imgConstraint_POS_H];
    [profileImageView5 addConstraints:imgConstraint_POS_V];
}

-(void)addProfileImage6Constraints
{
    NSDictionary *imageDict = @{@"imageView":profileImageView, @"imageView2":profileImageView2, @"imageView3":profileImageView3, @"imageView4": profileImageView4, @"imageView5":profileImageView5, @"imageView6":profileImageView6};
    NSArray *xPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView6]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *imgConstraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView6(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(CARD_HEIGHT)}
                                                                             views:imageDict];

    NSArray *imgConstraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView6(width)]"
                                                                           options:0
                                                                           metrics:@{@"width":@(CARD_WIDTH)}
                                                                             views:imageDict];

    NSArray *sixViewsCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-[imageView2]-[imageView3]-[imageView4]-[imageView5]-[imageView6]-5-|"
                                                options:0
                                                metrics:nil
                                                views:imageDict];
    [imageScroll addConstraints:xPosition];
    [profileImageView6 addConstraints:imgConstraint_POS_H];
    [profileImageView6 addConstraints:imgConstraint_POS_V];
    [imageScroll addConstraints:sixViewsCons];
}


#pragma mark -- VIEW INDICATOR CONSTRAINTS
-(void)addView1Constraints
{
    NSDictionary *viewDict = @{@"v1": v1};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v1(12)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];
    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v1(12)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewDict];
    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v1]-12-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];
    [v1 addConstraints:viewHeight];
    [v1 addConstraints:viewWidth];
    [self addConstraints:trailingH];
}

-(void)addView2Constraints
{
    NSDictionary *viewDict = @{@"v2": v2};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v2(12)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];
    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v2(12)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewDict];
    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v2]-12-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];
    [v2 addConstraints:viewHeight];
    [v2 addConstraints:viewWidth];
    [self addConstraints:trailingH];
}

-(void)addView3Constraints
{
    NSDictionary *viewDict = @{@"v3": v3};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v3(12)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewDict];
    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v3(12)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v3]-12-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    [v3 addConstraints:viewHeight];
    [v3 addConstraints:viewWidth];
    [self addConstraints:trailingH];
}

-(void)addView4Constraints
{
    NSDictionary *viewDict = @{@"v4": v4};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v4(12)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewDict];
    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v4(12)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v4]-12-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    [v4 addConstraints:viewHeight];
    [v4 addConstraints:viewWidth];
    [self addConstraints:trailingH];
}

-(void)addView5Constraints
{
    NSDictionary *viewDict = @{@"v5": v5};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v5(12)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewDict];
    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v5(12)]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v5]-12-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewDict];
    [v5 addConstraints:viewHeight];
    [v5 addConstraints:viewWidth];
    [self addConstraints:trailingH];
}

-(void)addView6Constraints
{
    NSDictionary *viewDict = @{@"v1":v1, @"v2":v2, @"v3":v3, @"v4":v4, @"v5":v5, @"v6":v6};
    NSArray *viewHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[v6(12)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];

    NSArray *viewWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v6(12)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:viewDict];

    NSArray *trailingH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[v6]-12-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];

    NSArray *sixSpaces = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[v1]-2-[v2]-2-[v3]-2-[v4]-2-[v5]-2-[v6]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewDict];
    [v6 addConstraints:viewHeight];
    [v6 addConstraints:viewWidth];
    [self addConstraints:trailingH];
    [self addConstraints:sixSpaces];
}
@end
