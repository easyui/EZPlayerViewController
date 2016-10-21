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

@interface EZPlayerViewController : UIViewController
@property (copy, nonatomic) NSString * playerTitle;
@property (copy, nonatomic) NSString * playerDescription;
@property (strong, nonatomic) NSURL * url;



@property (strong, nonatomic) AVPlayerViewController * playViewController;
@property (weak, nonatomic) UIView *  customContentView;





- (void)playerWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;



@end
