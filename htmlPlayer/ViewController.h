//
//  ViewController.h
//  htmlPlayer
//
//  Created by 李赛 on 16/1/18.
//  Copyright © 2016年 李赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerView.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) VideoPlayerView *videoView;
@end

