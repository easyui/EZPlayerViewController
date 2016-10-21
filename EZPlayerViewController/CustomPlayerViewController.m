//
//  CustomPlayerViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/10/19.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "CustomPlayerViewController.h"
#import "EZPlayerViewController.h"



@interface CustomPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *customView;
//@property (strong, nonatomic)  UIView *avNowPlayingTransportBarPoint;

//@property (strong, nonatomic)  NSTimer *updatePlayerTimer;
//@property (strong, nonatomic)   UISwipeGestureRecognizer *swipeRecognizer;

@end

@implementation CustomPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customContentView = self.customView;
    self.isCustomContentViewHidden = YES;
    // Do any additional setup after loading the view.

   
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"CustomPlayerViewController  释放");

}


- (void)playViewController:(EZPlayerViewController *)playViewController handleCustomContentView:(UIView *)customContentView isHidden:(BOOL)isHidden completionHandler:(void(^)())completionHandler{
    self.customContentView.hidden = isHidden;
    if (self.customContentView.hidden) {
        [self.view sendSubviewToBack:self.customContentView];
        completionHandler();
    }else{
        [self.view bringSubviewToFront:self.customContentView];
        self.customContentView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            self.customContentView.alpha = 1;
        } completion:^(BOOL finished) {
            completionHandler();
        }];
    }
}



@end
