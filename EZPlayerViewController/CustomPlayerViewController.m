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



@end
