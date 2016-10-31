//
//  EZPlayerViewController.h
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#define EZPlayerViewControllerExitFullScreenNotification   @"EZPlayerViewControllerExitFullScreenNotification"
#define EZPlayerViewControllerDidPlayToEndTimeNotification   @"EZPlayerViewControllerDidPlayToEndTimeNotification"


@interface EZPlayerViewController : UIViewController
@property (copy, nonatomic) NSString * playerTitle;
@property (copy, nonatomic) NSString * playerDescription;
@property (strong, nonatomic) NSURL * url;



@property (strong, nonatomic) AVPlayerViewController * playViewController;
//custom view
@property (weak, nonatomic) UIView *  customContentView;
@property (assign, nonatomic)  BOOL isCustomContentViewHidden;
//embedded view
@property (weak, nonatomic) UIView *  embeddedContentView;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)assetURL;


- (void)playWithURL:(NSURL *)assetURL;
- (void)play;
- (void)pause;
- (void)seekToTime:(float)seconds;
- (void)seekToTime:(float)seconds completionHandler:(void (^)(BOOL finished))completionHandler;
- (void)stop;
- (BOOL)isPlaying;

- (NSTimeInterval)currentTime;



- (void)playViewController:(EZPlayerViewController *)playViewController handleCustomContentView:(UIView *)customContentView isHidden:(BOOL)isHidden completionHandler:(void(^)())completionHandler;

@end
