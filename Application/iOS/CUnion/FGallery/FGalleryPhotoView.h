//
//  FGalleryPhotoView.h
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol FGalleryPhotoViewDelegate;

@interface FGalleryPhotoView : UIScrollView <UIScrollViewDelegate> {
	
	UIImageView *imageView;
	UIActivityIndicatorView *_activity;
	UIButton *_button;
	BOOL _isZoomed;
	NSTimer *_tapTimer;
	NSObject <FGalleryPhotoViewDelegate> *__unsafe_unretained photoDelegate;
}

- (void)killActivityIndicator;

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)resetZoom;

@property (nonatomic,unsafe_unretained) NSObject <FGalleryPhotoViewDelegate> *photoDelegate;
@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,readonly) UIActivityIndicatorView *activity;

@end



@protocol FGalleryPhotoViewDelegate

- (void)didTapPhotoView:(FGalleryPhotoView*)photoView;

@end

