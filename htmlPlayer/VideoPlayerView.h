//
//  VideoPlayerView.h
//  htmlPlayer
//
//  Created by 李赛 on 16/1/27.
//  Copyright © 2016年 李赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullViewController.h"
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (MIN(kScreenWidth, kScreenHeight)/320))
@import AVFoundation;
@class AVPlayer;

#define PLAYSPEED 0.03
@interface VideoPlayerView : UIView
{
    CGPoint beganPoint;//手势开始位置
    CGPoint translationPoint;//手势
    CGPoint preEndPoint;
    CGRect preFrame;//旋转之前的frame；
    NSTimeInterval preCurrentTime;
}

@property (weak, nonatomic) IBOutlet UIView *playerNavBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *playerControlBar;
@property (weak, nonatomic) IBOutlet UIImageView *playerControlBarBackground;
@property (weak, nonatomic) IBOutlet UIButton *pausePlayButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLable;
@property (weak, nonatomic) IBOutlet UISlider *videoScrubberSlider;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *asset;
@property (strong, nonatomic) AVPlayer *player;
@property (readonly) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, strong) FullViewController *fullVc;///<全屏控制器
@property (nonatomic, strong)  id<NSObject> timeObserverToken;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIViewController *controlViewController;

- (void)startLoadPlayerVideoWithUrl:(NSString *)Url;

//- (void)addVideoPlayerViewAtVC:(UIViewController *)controlVC andUrl:(NSString *)url viewFrame:(CGRect)frame;

@end

