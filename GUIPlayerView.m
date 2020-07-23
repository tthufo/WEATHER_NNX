//
//  GUIPlayerView.m
//  GUIPlayerView
//
//  Created by Guilherme Araújo on 08/12/14.
//  Copyright (c) 2014 Guilherme Araújo. All rights reserved.
//

#import "GUIPlayerView.h"
#import "GUISlider.h"

#import "UIView+UpdateAutoLayoutConstraints.h"

@interface GUIPlayerView () <AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) UIView *controllersView, *topView;;
@property (strong, nonatomic) UIImageView* coverView;
@property (strong, nonatomic) UILabel *airPlayLabel;

@property (strong, nonatomic) MPVolumeView *volumeView;
@property (strong, nonatomic) GUISlider *progressIndicator;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *remainingTimeLabel;
@property (strong, nonatomic) UILabel *liveLabel;

@property (strong, nonatomic) UIView *spacerView;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) NSTimer *controllersTimer;
@property (assign, nonatomic) BOOL seeking;
@property (assign, nonatomic) CGRect defaultFrame;

@end

@implementation GUIPlayerView

@synthesize player, playerLayer, currentItem;
@synthesize controllersView, airPlayLabel;
@synthesize playButton, fullscreenButton, volumeView, progressIndicator, currentTimeLabel, remainingTimeLabel, liveLabel, spacerView;
@synthesize activityIndicator, progressTimer, controllersTimer, seeking, fullscreen, defaultFrame;
@synthesize retryButton, topView, options, coverView;
@synthesize videoURL, controllersTimeoutPeriod, delegate, isRight;

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    defaultFrame = frame;
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andInfo:(NSMutableDictionary*)info {
    self = [super initWithFrame:frame];
    defaultFrame = frame;
    options = info;
    [self setup];
    return self;
}

- (void)setup {
    // Set up notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFailedToPlayToEnd:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayAvailabilityChanged:)
                                                 name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayActivityChanged:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    NSArray *horizontalConstraints;
    NSArray *verticalConstraints;
    
    
    /** Container View **************************************************************************************************/
    
    if(options)
    {
        coverView = [UIImageView new];
        coverView.clipsToBounds = YES;
        coverView.contentMode = UIViewContentModeScaleAspectFill;
        
        [coverView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:coverView];
        
        horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CC]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"CC" : coverView}];
        
        verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[CC]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"CC" : coverView}];
        [self addConstraints:horizontalConstraints];
        [self addConstraints:verticalConstraints];
        
        coverView.image = options[@"cover"] ? options[@"cover"] : [UIImage imageNamed:@""];
        
        
        topView = [UIView new];
        [topView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.45f]];
        [topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:topView];
        
        horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[T(40)]" options:0 metrics:nil views:@{@"T":topView}];
        
        verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[T(80)]" options:0 metrics:nil views:@{@"T":topView}];
        
        [self addConstraints:horizontalConstraints];
        
        [self addConstraints:verticalConstraints];
        
        
        UIButton * repeat = [UIButton buttonWithType:UIButtonTypeCustom];
        [repeat setTranslatesAutoresizingMaskIntoConstraints:NO];
        [repeat setImage:[UIImage imageNamed:[options[@"repeat"] isEqualToString:@"0"] ? @"none" : [options[@"repeat"] isEqualToString:@"1"] ? @"one" : @"all"] forState:UIControlStateNormal];
        
        [topView addSubview:repeat];
        
        
        UIButton * shuffle = [UIButton buttonWithType:UIButtonTypeCustom];
        [shuffle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [shuffle setImage:[UIImage imageNamed:[options[@"shuffle"] isEqualToString:@"0"] ? @"shuffle_ac" : @"shuffle_in"] forState:UIControlStateNormal];
        
        [topView addSubview:shuffle];
        
        verticalConstraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[RP(40)][SS(40)]|"
                               options:0
                               metrics:nil
                               views:@{@"RP" : repeat,@"SS": shuffle}];
        
        horizontalConstraints = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|[RP(40)][SS(40)]|"
                                 options:0
                                 metrics:nil
                                 views:@{@"RP" : repeat,@"SS": shuffle}];
        
        [topView addConstraints:verticalConstraints];
        
        [topView addConstraints:horizontalConstraints];
        
        [repeat addTarget:self action:@selector(didPressRepeat:) forControlEvents:UIControlEventTouchUpInside];
        
        [shuffle addTarget:self action:@selector(didPressShuffle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    controllersView = [UIView new];
    [controllersView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controllersView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.45f]];
    
    [self addSubview:controllersView];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CV]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"CV" : controllersView}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[CV(40)]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"CV" : controllersView}];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    
    /** AirPlay View ****************************************************************************************************/
    
    airPlayLabel = [UILabel new];
    [airPlayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [airPlayLabel setText:@"AirPlay is enabled"];
    [airPlayLabel setTextColor:[UIColor lightGrayColor]];
    [airPlayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [airPlayLabel setTextAlignment:NSTextAlignmentCenter];
    [airPlayLabel setNumberOfLines:0];
    [airPlayLabel setHidden:YES];
    
    [self addSubview:airPlayLabel];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[AP]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"AP" : airPlayLabel}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[AP]-40-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"AP" : airPlayLabel}];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    
    /** UI Controllers **************************************************************************************************/
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [playButton setImage:[UIImage imageNamed:@"gui_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"gui_pause"] forState:UIControlStateSelected];
    
    volumeView = [MPVolumeView new];
    [volumeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [volumeView setShowsRouteButton:YES];
    [volumeView setShowsVolumeSlider:NO];
    [volumeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullscreenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullscreenButton setImage:[UIImage imageNamed:@"gui_expand"] forState:UIControlStateNormal];
    [fullscreenButton setImage:[UIImage imageNamed:@"gui_shrink"] forState:UIControlStateSelected];
    
    currentTimeLabel = [UILabel new];
    [currentTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [currentTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [currentTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [currentTimeLabel setTextColor:[UIColor whiteColor]];
    
    remainingTimeLabel = [UILabel new];
    [remainingTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [remainingTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [remainingTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [remainingTimeLabel setTextColor:[UIColor whiteColor]];
    
    progressIndicator = [GUISlider new];
    [progressIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [progressIndicator setContinuous:YES];
    progressIndicator.userInteractionEnabled = NO;
    
    liveLabel = [UILabel new];
    [liveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [liveLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [liveLabel setTextAlignment:NSTextAlignmentCenter];
    [liveLabel setTextColor:[UIColor whiteColor]];
    [liveLabel setText:@"Try again"];
    [liveLabel setHidden:YES];
    
    
    
    spacerView = [UIView new];
    [spacerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [controllersView addSubview:playButton];
    [controllersView addSubview:fullscreenButton];
    [controllersView addSubview:volumeView];
    [controllersView addSubview:currentTimeLabel];
    [controllersView addSubview:progressIndicator];
    [controllersView addSubview:remainingTimeLabel];
    [controllersView addSubview:liveLabel];
    [controllersView addSubview:spacerView];
    
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[P(40)][S(10)][C]-5-[I]-5-[R][F(40)][V(40)]|"
                             options:0
                             metrics:nil
                             views:@{@"P" : playButton,
                                     @"S" : spacerView,
                                     @"C" : currentTimeLabel,
                                     @"I" : progressIndicator,
                                     @"R" : remainingTimeLabel,
                                     @"V" : volumeView,
                                     @"F" : fullscreenButton}];
    
    [controllersView addConstraints:horizontalConstraints];
    
    [volumeView hideByWidth:YES];
    [spacerView hideByWidth:YES];
    
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-5-[L]-5-|"
                             options:0
                             metrics:nil
                             views:@{@"L" : liveLabel}];
    
    [controllersView addConstraints:horizontalConstraints];
    
    for (UIView *view in [controllersView subviews]) {
        verticalConstraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[V(40)]"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"V" : view}];
        [controllersView addConstraints:verticalConstraints];
    }
    
    
    /** Loading Indicator ***********************************************************************************************/
    
    retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [retryButton setImage:[UIImage imageNamed:@"retry"] forState:UIControlStateNormal];
    
    retryButton.hidden = YES;
    
    activityIndicator = [UIActivityIndicatorView new];
    
    [activityIndicator stopAnimating];
    
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    [activityIndicator setFrame:frame];
    
    retryButton.frame = frame;
    
    [self addSubview:retryButton];
    
    [self addSubview:activityIndicator];
    
    [retryButton addTarget:self action:@selector(didPressReTry) forControlEvents:UIControlEventTouchUpInside];
    
    
    /** Actions Setup ***************************************************************************************************/
    
    [playButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenButton addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [progressIndicator addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
    [progressIndicator addTarget:self action:@selector(pauseRefreshing) forControlEvents:UIControlEventTouchDown];
    [progressIndicator addTarget:self action:@selector(resumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
     UIControlEventTouchUpOutside | UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControllers)]];
    [self showControllers];
    
    controllersTimeoutPeriod = 3;
    
    ///////// new added
    
    if(options[@"currentTime"])
    {
        [(UILabel*)options[@"currentTime"] setText:@""];
    }
    
    if(options[@"remainTime"])
    {
        [(UILabel*)options[@"remainTime"] setText:@""];
    }
    
    if(options[@"thumb"])
    {
        [progressIndicator setThumbImage:options[@"thumb"] forState:UIControlStateNormal];
        
        [progressIndicator setThumbImage:options[@"thumb"] forState:UIControlStateHighlighted];
    }
    
    if(options[@"slider"])
    {
        [options[@"slider"] addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
        [options[@"slider"] addTarget:self action:@selector(pauseRefreshing) forControlEvents:UIControlEventTouchDown];
        [options[@"slider"] addTarget:self action:@selector(resumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
         UIControlEventTouchUpOutside | UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
    }
    
    if(options[@"multi"])
    {
        for(NSDictionary * dict in options[@"multi"])
        {
            [dict[@"slider"] addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
            [dict[@"slider"] addTarget:self action:@selector(pauseRefreshing) forControlEvents:UIControlEventTouchDown];
            [dict[@"slider"] addTarget:self action:@selector(resumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
             UIControlEventTouchUpOutside | UIControlEventTouchDragInside | UIControlEventTouchDragOutside];
            
            if(dict[@"currentTime"])
            {
                [(UILabel*)dict[@"currentTime"] setText:@""];
            }
            
            if(dict[@"remainTime"])
            {
                [(UILabel*)dict[@"remainTime"] setText:@""];
            }
        }
    }
}

#pragma mark - UI Customization

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    [progressIndicator setTintColor:tintColor];
}

- (void)setBufferTintColor:(UIColor *)tintColor {
    [progressIndicator setSecondaryTintColor:tintColor];
}

- (void)setLiveStreamText:(NSString *)text {
    [liveLabel setText:text];
}

- (void)setAirPlayText:(NSString *)text {
    [airPlayLabel setText:text];
}

#pragma mark - Actions

- (void)didPressRepeat:(UIButton*)sender
{
    if(options)
    {
        int option = [options[@"repeat"] intValue] == 0 ? 1 : [options[@"repeat"] intValue] == 1 ? 2 : 0 ;
        options[@"repeat"] = [NSString stringWithFormat:@"%i", option];
        [sender setImage:[UIImage imageNamed:[options[@"repeat"] isEqualToString:@"0"] ? @"none" : [options[@"repeat"] isEqualToString:@"1"] ? @"one" : @"all"] forState:UIControlStateNormal];
    }
}

- (void)didPressShuffle:(UIButton*)sender
{
    if(options)
    {
        int option = [options[@"shuffle"] intValue] == 0 ? 1 : 0;
        options[@"shuffle"] = [NSString stringWithFormat:@"%i", option];
        [sender setImage:[UIImage imageNamed:[options[@"shuffle"] isEqualToString:@"0"] ? @"shuffle_ac" : @"shuffle_in"] forState:UIControlStateNormal];
    }
}

- (void)didPressReTry
{
    if ([delegate respondsToSelector:@selector(playerRetry)]) {
        [delegate playerRetry];
    }
}

- (void)togglePlay:(UIButton *)button {
    if ([button isSelected]) {
        [button setSelected:NO];
        [player pause];
        
        if ([delegate respondsToSelector:@selector(playerDidPause)]) {
            [delegate playerDidPause];
        }
    } else {
        [button setSelected:YES];
        [self play];
        
        if ([delegate respondsToSelector:@selector(playerDidResume)]) {
            [delegate playerDidResume];
        }
    }
    
    [self showControllers];
}

- (void)toggleFullscreen:(UIButton *)button {
    if (fullscreen) {
        if ([delegate respondsToSelector:@selector(playerWillLeaveFullscreen)]) {
            [delegate playerWillLeaveFullscreen];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            [self setTransform:CGAffineTransformMakeRotation(0)];
            [self setFrame:defaultFrame];
            
            CGRect frame = defaultFrame;
            frame.origin = CGPointZero;
            [playerLayer setFrame:frame];
            [activityIndicator setFrame:frame];
        } completion:^(BOOL finished) {
            fullscreen = NO;
            
            if ([delegate respondsToSelector:@selector(playerDidLeaveFullscreen)]) {
                [delegate playerDidLeaveFullscreen];
            }
        }];
        
        [button setSelected:NO];
    } else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat height = [[UIScreen mainScreen] bounds].size.height;
        CGRect frame;
        
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            CGFloat aux = width;
            width = height;
            height = aux;
            frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
        }
        else
        {
            frame = CGRectMake(0, 0, width, height);
        }
        
        if ([delegate respondsToSelector:@selector(playerWillEnterFullscreen)]) {
            [delegate playerWillEnterFullscreen];
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            [self setFrame:frame];
            [playerLayer setFrame:CGRectMake(0, 0, width, height)];
            
            [activityIndicator setFrame:CGRectMake(0, 0, width, height)];
            if (UIInterfaceOrientationIsPortrait(orientation)) {
                [self setTransform:CGAffineTransformMakeRotation(M_PI_2 * (isRight ? -1 : 1))];
                [activityIndicator setTransform:CGAffineTransformMakeRotation(-M_PI_2 * (isRight ? -1 : 1))];
            }
            
        } completion:^(BOOL finished) {
            fullscreen = YES;
            
            if ([delegate respondsToSelector:@selector(playerDidEnterFullscreen)]) {
                [delegate playerDidEnterFullscreen];
            }
        }];
        
        [button setSelected:YES];
    }
    
    [self showControllers];
}

- (void)seekTo:(float)value
{
//    int timescale = currentItem.asset.duration.timescale;
//    float time = value * (currentItem.asset.duration.value / timescale);
//    [player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
}

- (void)seek:(UISlider *)slider {
    int timescale = currentItem.asset.duration.timescale;
    float time = slider.value * (currentItem.asset.duration.value / timescale);
    
    [player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
    
    [self showControllers];
}

- (void)pauseRefreshing {
    seeking = YES;
    
    [progressTimer invalidate];
}

- (void)resumeRefreshing {
    seeking = NO;
    
    [progressTimer invalidate];
    
    progressTimer = nil;
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector(refreshProgressIndicator)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (NSTimeInterval)availableDuration
{
    NSTimeInterval result = 0;
    NSArray *loadedTimeRanges = player.currentItem.loadedTimeRanges;
    
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        result = startSeconds + durationSeconds;
    }
    
    return result;
}

- (void)refreshProgressIndicator {
    CGFloat duration = CMTimeGetSeconds(currentItem.asset.duration);
    
    if (duration == 0 || isnan(duration)) {
        // Video is a live stream
        [currentTimeLabel setText:nil];
        [remainingTimeLabel setText:nil];
        [progressIndicator setHidden:YES];
        [liveLabel setHidden:NO];
        [playButton setSelected:NO];
        
        if(fullscreen)
        {
            [self toggleFullscreen:nil];
        }
        
        [self hideControllers];
        
        if ([delegate respondsToSelector:@selector(playerError)]) {
            [delegate playerError];
        }
        [progressTimer invalidate];
        progressTimer = nil;
    }
    
    else {
        CGFloat current = seeking ?
        progressIndicator.value * duration :         // If seeking, reflects the position of the slider
        CMTimeGetSeconds(player.currentTime); // Otherwise, use the actual video position
        
        [progressIndicator setValue:(current / duration)];
        [progressIndicator setSecondaryValue:([self availableDuration] / duration)];
                
        if(options[@"slider"])
        {
            CGFloat current = seeking ?
            
            ((GUISlider*)options[@"slider"]).value * duration : CMTimeGetSeconds(player.currentTime);
            
            [((GUISlider*)options[@"slider"]) setValue:(current / duration)];
            
            [((GUISlider*)options[@"slider"]) setSecondaryValue:([self availableDuration] / duration)];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:(duration >= 3600 ? @"hh:mm:ss": @"mm:ss")];
        
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:current];
        NSDate *remainingTime = [NSDate dateWithTimeIntervalSince1970:(duration - current)];
        
        [currentTimeLabel setText:[formatter stringFromDate:currentTime]];
        [remainingTimeLabel setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
        
        if(options[@"currentTime"])
        {
            [(UILabel*)options[@"currentTime"] setText:[formatter stringFromDate:currentTime]];
        }
        
        if(options[@"remainTime"])
        {
            [(UILabel*)options[@"remainTime"] setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
        }
        
        if(options[@"multi"])
        {
            for(NSDictionary * dict in options[@"multi"])
            {
                CGFloat current = seeking ?
                
                ((GUISlider*)dict[@"slider"]).value * duration : CMTimeGetSeconds(player.currentTime);
                
                [((GUISlider*)dict[@"slider"]) setValue:(current / duration)];
                
                [((GUISlider*)dict[@"slider"]) setSecondaryValue:([self availableDuration] / duration)];
                
                if(dict[@"currentTime"])
                {
                    [(UILabel*)dict[@"currentTime"] setText:[formatter stringFromDate:currentTime]];
                }
                
                if(dict[@"remainTime"])
                {
                    [(UILabel*)dict[@"remainTime"] setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
                }
            }
        }
        
        [progressIndicator setHidden:NO];
        [liveLabel setHidden:YES];
        retryButton.hidden = YES;
    }
}

- (void)showControllers {
    [UIView animateWithDuration:0.2f animations:^{
        [controllersView setAlpha:1.0f];
        [topView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [controllersTimer invalidate];
        
        if (controllersTimeoutPeriod > 0) {
            controllersTimer = [NSTimer scheduledTimerWithTimeInterval:controllersTimeoutPeriod
                                                                target:self
                                                              selector:@selector(hideControllers)
                                                              userInfo:nil
                                                               repeats:NO];
        }
    }];
}

- (void)hideControllers {
    [UIView animateWithDuration:0.5f animations:^{
        [controllersView setAlpha:0.0f];
        [topView setAlpha:0.0f];
    }];
}

#pragma mark - Public Methods

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically {
    if (player) {
        [self stop];
    }
    
    player = [[AVPlayer alloc] initWithPlayerItem:nil];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSArray *keys = [NSArray arrayWithObject:@"playable"];
    
    __weak typeof(self) weakSelf = self;
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        weakSelf.currentItem = [AVPlayerItem playerItemWithAsset:asset];
        [weakSelf.player replaceCurrentItemWithPlayerItem:weakSelf.currentItem];
        
        if (playAutomatically) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf play];
            });
        }
    }];
    
    [player setAllowsExternalPlayback:YES];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.layer addSublayer:playerLayer];
    
    defaultFrame = self.frame;
    
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    [playerLayer setFrame:frame];
    
    [self bringSubviewToFront:controllersView];
    [self bringSubviewToFront:topView];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    [currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    [player seekToTime:kCMTimeZero];
    [player setRate:0.0f];
    [playButton setSelected:YES];
    
    if (playAutomatically) {
        [activityIndicator startAnimating];
    }
}

- (void)clean {
    
    [progressTimer invalidate];
    progressTimer = nil;
    [controllersTimer invalidate];
    controllersTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    
    [player setAllowsExternalPlayback:NO];
    [self stop];
    [player removeObserver:self forKeyPath:@"rate"];
    @try{
        [currentItem removeObserver:self forKeyPath:@"status"];
    }@catch(id anException){
    }
    [self setPlayer:nil];
    [self.playerLayer removeFromSuperlayer];
    [self setPlayerLayer:nil];
    [self removeFromSuperview];
    options = nil;
}

- (void)play {
    
    [player play];
    
    [playButton setSelected:YES];
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector(refreshProgressIndicator)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)pause {
    [player pause];
    
    [playButton setSelected:NO];
    
    if ([delegate respondsToSelector:@selector(playerDidPause)]) {
        [delegate playerDidPause];
    }
    
    [progressTimer invalidate];
    
    progressTimer = nil;
}

- (void)stop {
    if (player) {
        [player pause];
        [player seekToTime:kCMTimeZero];
        
        [playButton setSelected:NO];
    }
    [progressTimer invalidate];
    
    progressTimer = nil;
}

- (BOOL)isPlaying {
    return [player rate] > 0.0f;
}

- (void)setVolume:(float)value
{
    [player setVolume:value];
}

- (float)getVolume
{
    return player.volume;
}

#pragma mark - AV Player Notifications and Observers

- (void)playerDidFinishPlaying:(NSNotification *)notification {
    [self stop];
    
    if (fullscreen) {
        [self toggleFullscreen:fullscreenButton];
    }
    
    if ([delegate respondsToSelector:@selector(playerDidEndPlaying)]) {
        [delegate playerDidEndPlaying];
    }
}

- (void)playerFailedToPlayToEnd:(NSNotification *)notification {
    [self stop];
    
    if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
        [delegate playerFailedToPlayToEnd];
    }
}

- (void)playerStalled:(NSNotification *)notification {
    [self togglePlay:playButton];
    
    if ([delegate respondsToSelector:@selector(playerStalled)]) {
        [delegate playerStalled];
    }
}


- (void)airPlayAvailabilityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([volumeView areWirelessRoutesAvailable]) {
                             [volumeView hideByWidth:NO];
                         } else if (! [volumeView isWirelessRouteActive]) {
                             [volumeView hideByWidth:YES];
                         }
                         [self layoutIfNeeded];
                     }];
}


- (void)airPlayActivityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([volumeView isWirelessRouteActive]) {
                             if (fullscreen)
                                 [self toggleFullscreen:fullscreenButton];
                             
                             [playButton hideByWidth:YES];
                             [fullscreenButton hideByWidth:YES];
                             [spacerView hideByWidth:NO];
                             
                             [airPlayLabel setHidden:NO];
                             
                             controllersTimeoutPeriod = 0;
                             [self showControllers];
                         } else {
                             [playButton hideByWidth:NO];
                             [fullscreenButton hideByWidth:NO];
                             [spacerView hideByWidth:YES];
                             
                             [airPlayLabel setHidden:YES];
                             
                             controllersTimeoutPeriod = 3;
                             [self showControllers];
                         }
                         [self layoutIfNeeded];
                     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (currentItem.status == AVPlayerItemStatusFailed) {
            if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
                [delegate playerFailedToPlayToEnd];
            }
        }
        
        if (currentItem.status == AVPlayerItemStatusReadyToPlay) {
            if ([delegate respondsToSelector:@selector(playerReadyToPlay)]) {
                [delegate playerReadyToPlay];
            }
        }
        
    }
    
    if ([keyPath isEqualToString:@"rate"]) {
        CGFloat rate = [player rate];
        if (rate > 0) {
            [activityIndicator stopAnimating];
            progressIndicator.userInteractionEnabled = YES;
            if ([delegate respondsToSelector:@selector(playerReadyToPlay)]) {
                if(progressIndicator.value == 0)
                {
                    [delegate playerReadyToPlay];
                    
                    coverView.image = [UIImage imageNamed:@""];
                }
            }
        }
    }
}

- (void)dealloc {
}

@end
