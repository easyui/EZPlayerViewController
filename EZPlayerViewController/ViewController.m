//
//  ViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "ViewController.h"
#import "EZPlayerViewController.h"
#import "CustomPlayerViewController.h"
#import "PresentedViewController.h"

@interface ViewController ()
@property(nonatomic,strong) EZPlayerViewController * playerViewController;
@property(nonatomic,strong) PresentedViewController * sspresentedViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fullscreenplayButtonAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreenNotification:) name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    self.playerViewController = [[CustomPlayerViewController alloc] initWithNibName:@"CustomPlayerViewController" bundle:nil];
    self.playerViewController.playerTitle = @"title";
    self.playerViewController.playerDescription = @"desc";
    [self.playerViewController playWithURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    [self presentViewController:self.playerViewController animated:YES completion:nil];
    
    
//    CustomPlayerViewController *playerViewController = [[CustomPlayerViewController alloc] initWithNibName:@"CustomPlayerViewController" bundle:nil];
//    [playerViewController loadFromUrl:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
//    [self presentViewController:playerViewController animated:YES completion:nil];
    
//        self.sspresentedViewController = [[PresentedViewController alloc] initWithNibName:@"PresentedViewController" bundle:nil];
//        [self presentViewController:self.sspresentedViewController animated:YES completion:nil];


}

- (void)exitFullScreenNotification:(NSNotification *)notification{
    [self.playerViewController stop];
    self.playerViewController = nil;
}
@end
