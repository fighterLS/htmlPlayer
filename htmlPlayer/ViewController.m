//
//  ViewController.m
//  htmlPlayer
//
//  Created by 李赛 on 16/1/18.
//  Copyright © 2016年 李赛. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UIWebViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://www.iqiyi.com/a_19rrhb2oed.html
    //http://v.youku.com/v_show/id_XMTQyMzgxODgzNg==.html
    //http://tv.sohu.com/20151003/n422558472.shtml
    //http://www.letv.com/ptv/vplay/24533440.html
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tv.sohu.com/20151003/n422558472.shtml"]]];
    self.webView.delegate=self;
    self.webView.allowsInlineMediaPlayback=YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videotest" ofType:@"js"];
    NSString *videoHandlerString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  
    if (videoHandlerString) {
   
        [webView stringByEvaluatingJavaScriptFromString:videoHandlerString];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:@"objc"]) {
        NSLog(@"url = %@" ,request.URL);
        NSString *urlString=[NSString stringWithFormat:@"%@",request.URL];
        NSRange range=[urlString rangeOfString:@"objc://URL/"];
        NSString *subString=nil;
        if (range.length>0) {
            subString=[urlString substringFromIndex:range.location+range.length];
        }
        if (subString) {
             [self plauerViewWithUrl:subString];
        }
   
        return NO;
    }
  
    return YES;
}


-(void)plauerViewWithUrl:(NSString *)Url
{
    if (_videoView==nil) {
        _videoView=[[[NSBundle mainBundle] loadNibNamed:@"VideoPlayerView" owner:self options:nil] lastObject];
        _videoView.frame = CGRectMake(0, 20, kScreenWidth, kScaleFrom_iPhone5_Desgin(180));
        _videoView.controlViewController=self;
    }
    [_videoView startLoadPlayerVideoWithUrl:Url];
    if (![self isExistSubView]) {
     [self.view addSubview:_videoView];
    }
}
-(BOOL)isExistSubView
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[VideoPlayerView class]]) {
            return YES;
        }
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
