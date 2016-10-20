//
//  EZPlayerViewController.h
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface EZPlayerViewController : UIViewController
@property (nonatomic, strong) AVPlayerViewController * playViewController;
@property (nonatomic, weak) UIView *  customContentView;





- (void)loadFromUrl:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;



@end
