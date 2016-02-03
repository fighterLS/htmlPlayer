//
//  VideoPlayerView.m
//  htmlPlayer
//
//  Created by 李赛 on 16/1/27.
//  Copyright © 2016年 李赛. All rights reserved.
//

#import "VideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation VideoPlayerView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addGestureRecognizer:self.panGesture];
    [self.videoScrubberSlider setThumbImage:[UIImage imageNamed:@"customPlayerThumb"] forState:UIControlStateNormal];
}
- (void)startLoadPlayerVideoWithUrl:(NSString *)Url
{
    [self removeItemKVOOberservers];
    self.asset = [AVURLAsset assetWithURL:[NSURL URLWithString:Url]];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    [self addItemKVOObserver];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (AVPlayer *)player {
    
    if (_player==nil) {
        _player=[[AVPlayer alloc]init];
    }
    return _player;
}
// override UIView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

#pragma mark ---KVO---------
- (void)addPlayerTimeObservers
{
    [self syncPlayPauseButtons];
    __typeof(self) __weak weakSelf = self;
    _timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:
                          ^(CMTime time) {
                              [weakSelf syncPlayClock];
                          }];
}

-(void)removePlayerTimeObservers
{
    if (_timeObserverToken) {
        [self.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
}

- (void)addItemKVOObserver
{
    @try {
        [self.playerItem addObserver:self
                          forKeyPath:@"status"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        
        [self.playerItem addObserver:self
                          forKeyPath:@"playbackBufferEmpty"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        
        [self.playerItem addObserver:self
                          forKeyPath:@"playbackLikelyToKeepUp"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        
        [self.playerItem addObserver:self
                          forKeyPath:@"loadedTimeRanges"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
        // Use a weak self variable to avoid a retain cycle in the block.
        [self addPlayerTimeObservers];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        
    }
    
}

- (void)removeItemKVOOberservers
{
    @try {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        //        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
        
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self removePlayerTimeObservers];
    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                
            }
                break;
            case AVPlayerStatusFailed:{
            }
                break;
            case AVPlayerStatusUnknown:
                
                break;
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"] && self.player.currentItem.playbackBufferEmpty)
    {
        
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"] && self.player.currentItem.playbackLikelyToKeepUp)
    {
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        float durationTime = CMTimeGetSeconds([[self.player currentItem] duration]);
        NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
        if (loadedTimeRanges.count>0) {
            CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
            float bufferTime =CMTimeGetSeconds(timeRange.start)+ CMTimeGetSeconds(timeRange.duration);
            [self.progressView setProgress:bufferTime/durationTime animated:YES];
        }
        
    }
    
    return;
}

#pragma mark - Properties
-(UIPanGestureRecognizer *)panGesture
{
    if (_panGesture==nil) {
        _panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleAttachmentGesture:)];
    }
    return _panGesture;
}
- (NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.player.currentTime);
}

- (NSTimeInterval)duration {
    return self.player.currentItem ? CMTimeGetSeconds(self.player.currentItem.duration) : CMTimeGetSeconds(kCMTimeZero);
}
- (void)setPlayerItem:(AVPlayerItem *)newPlayerItem {
    if (_playerItem != newPlayerItem) {
        
        _playerItem = newPlayerItem;
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        [self.player play];
        self.playerLayer.player=self.player;
    }
}
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}
#pragma mark------convienience Method---
- (void)closeVideoPlayer
{
    [self removeItemKVOOberservers];
    self.playerItem=nil;
    self.player=nil;
    [self removeFromSuperview];
}
- (BOOL)isPlaying
{
    return [_player rate] != 0.0;
}
- (void)syncPlayPauseButtons
{
    if ([self isPlaying]) {
        [self.pausePlayButton setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
    } else {
        [self.pausePlayButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    }
}
- (NSString *)stringFormattedTimeFromSeconds:(NSTimeInterval)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"mm:ss"];
    return [formatter stringFromDate:date];
}
- (void)syncPlayClock
{
    NSTimeInterval duration =self.duration;
    if (isfinite(duration))
    {
        NSTimeInterval currentTime = self.currentTime;
        self.currentTimeLable.text=[NSString stringWithFormat:@"%@/%@",[self stringFormattedTimeFromSeconds:currentTime],[self stringFormattedTimeFromSeconds:duration]];
        self.videoScrubberSlider.value=currentTime/duration;
    }
}
- (void)handleAttachmentGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint velocityPoint = [panGesture velocityInView:self];
    CGPoint endPoint = [panGesture locationInView:self];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        beganPoint =[panGesture locationInView:self];
        preCurrentTime =[self currentTime];
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if(translationPoint.x ==0 && translationPoint.y == 0){
            translationPoint = [panGesture translationInView:self];
        }
        if (fabs(endPoint.x-beganPoint.x) > fabs(endPoint.y-beganPoint.y) && fabs(translationPoint.x) >fabs(translationPoint.y)) {
            if (endPoint.x-beganPoint.x < 0 )//快退
            {
                if(velocityPoint.x<0)//向左
                {
                    preCurrentTime = preCurrentTime-PLAYSPEED*fabs(endPoint.x-beganPoint.x);
                    preEndPoint.x=endPoint.x;
                }else
                {
                    preCurrentTime = preCurrentTime+PLAYSPEED*fabs(endPoint.x-preEndPoint.x);
                    
                }
            }else  //快进
            {
                if(velocityPoint.x<0)//向左
                {
                    preCurrentTime = preCurrentTime-PLAYSPEED*fabs(endPoint.x-preEndPoint.x);
                }else
                {
                    
                    preCurrentTime = preCurrentTime+PLAYSPEED*fabs(endPoint.x-beganPoint.x);
                    preEndPoint.x=endPoint.x;
                    
                }
            }
            [_videoScrubberSlider setValue:preCurrentTime / self.duration];
            [self scrubberDidBegin:self.videoScrubberSlider];
            [self scrubberIsScrolling:self.videoScrubberSlider];
        }else if(fabs(endPoint.x-beganPoint.x) < fabs(endPoint.y-beganPoint.y) && fabs(translationPoint.x)  < fabs(translationPoint.y)){
            if(endPoint.x < self.frame.size.width/2){
                if (beganPoint.y>=self.frame.size.height) {
                    return;
                }
                [UIScreen mainScreen].brightness +=(beganPoint.y -endPoint.y)/5000;
            }else {
                
                if (beganPoint.y>=self.frame.size.height) {
                    return;
                }
                if (beganPoint.y-endPoint.y>0) {  //加音量
                    
                    if (velocityPoint.y>0) {
                [MPMusicPlayerController applicationMusicPlayer].volume -=(beganPoint.y-preEndPoint.y)/5000;
                        
                    }else
                    {
                        
                        preEndPoint.y=endPoint.y;
                [MPMusicPlayerController applicationMusicPlayer].volume +=(beganPoint.y-endPoint.y)/5000;
                        
                    }
                }
                else
                {
                    NSLog(@"减音量");
                    if (velocityPoint.y>0) {
                        NSLog(@"向下");
                    [MPMusicPlayerController applicationMusicPlayer].volume +=(beganPoint.y-endPoint.y)/5000;
                        preEndPoint.y=endPoint.y;
                    }else
                    {
                        NSLog(@"向上");
                       [MPMusicPlayerController applicationMusicPlayer].volume -=(beganPoint.y-preEndPoint.y)/5000;
                    }
                }
            }
        }
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded ||panGesture.state == UIGestureRecognizerStateCancelled|| panGesture.state == UIGestureRecognizerStateFailed || panGesture.state == UIGestureRecognizerStatePossible ||panGesture.state == UIGestureRecognizerStatePossible) {
        translationPoint = CGPointZero;
        [self scrubberDidEnd:self.videoScrubberSlider];
    }else {
     //   translationPoint = CGPointZero;
       // [self scrubberDidEnd:self.videoScrubberSlider];
    }
    
}


#pragma mark ---Action-------
- (IBAction)fullScreenButtonAction:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        preFrame=self.frame;
        [self.controlViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.controlViewController.view addSubview:self];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                 self.frame = preFrame;
            } completion:nil];
           
        }];
    }

}

- (IBAction)scrubberDidBegin:(UISlider *)sender {
    if ([self isPlaying]) {
        [self.player pause];
        [self syncPlayPauseButtons];
    }
}
- (IBAction)scrubberIsScrolling:(UISlider *)sender {
    
    NSTimeInterval duration =self.duration;
    if (isfinite(duration))
    {
        NSTimeInterval currentTime = floor(duration * self.videoScrubberSlider.value);
        self.currentTimeLable.text=[NSString stringWithFormat:@"%@/%@",[self stringFormattedTimeFromSeconds:currentTime],[self stringFormattedTimeFromSeconds:duration]];
    }

}
- (IBAction)scrubberDidEnd:(UISlider *)sender {
    
    if ([self isPlaying])
    {
        return;
    }
    NSTimeInterval duration =self.duration;
    if (isfinite(duration))
    {
        NSTimeInterval currentTime = floor(duration * self.videoScrubberSlider.value);
        [self removePlayerTimeObservers];
        [self.player seekToTime:CMTimeMakeWithSeconds((float) currentTime, NSEC_PER_SEC) completionHandler:^(BOOL finished)
         {
             if (![self isPlaying])
             {
                 [self.player play];
                 [self syncPlayPauseButtons];
             }
             [self addPlayerTimeObservers];
         }];
    }

   
}

- (IBAction)pausePlayButtonAction:(UIButton *)sender {
    if ([self isPlaying]) {
        [self.player pause];
    }else
    {
        [self.player play];
    }
    [self syncPlayPauseButtons];
}
- (IBAction)backButtonAction:(UIButton *)sender {
    if ([self.superview isDescendantOfView:self.fullVc.view]) {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.controlViewController.view addSubview:self];
            self.fullScreenButton.selected=NO;
            self.frame = preFrame;
            [self closeVideoPlayer];
        }];
    }else {
        [self closeVideoPlayer];
    }

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
