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

@interface ViewController ()
@property(nonatomic,strong) EZPlayerViewController * playerViewController;
@property (weak, nonatomic) IBOutlet UIView *embeddedView;

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
    [self embedscrennstopButtonAction:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreenNotification:) name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    self.playerViewController = [[CustomPlayerViewController alloc] initWithNibName:@"CustomPlayerViewController" bundle:nil];
    self.playerViewController.playerTitle = @"title";
    self.playerViewController.playerDescription = @"desc";
    [self.playerViewController playWithURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    [self.playerViewController playWithURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];

    [self presentViewController:self.playerViewController animated:YES completion:nil];

}

- (IBAction)embedscrennplayButtonAction:(UIButton *)sender {
    [self embedscrennstopButtonAction:nil];
    [UIApplication sharedApplication].idleTimerDisabled=YES;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreenNotification:) name:EZPlayerViewControllerExitFullScreenNotification object:nil];
    self.playerViewController = [[CustomPlayerViewController alloc] initWithNibName:@"CustomPlayerViewController" bundle:nil];
    self.playerViewController.embeddedContentView = self.embeddedView;
    self.playerViewController.playerTitle = @"title";
    self.playerViewController.playerDescription = @"desc";
    [self.playerViewController playWithURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    [self.embeddedView addSubview:self.playerViewController.view];
    self.playerViewController.view.frame = self.embeddedView.bounds;
}

- (IBAction)embedscrennstopButtonAction:(UIButton *)sender {
    [self.playerViewController stop];
    [self.playerViewController.view removeFromSuperview];
    self.playerViewController = nil;
}

- (IBAction)embedToFullScreenButtonAction:(UIButton *)sender {
    if (self.playerViewController) {
        [self.playerViewController.view removeFromSuperview];
        [self presentViewController:self.playerViewController animated:YES completion:nil];
        
    }
    
    
}

- (void)exitFullScreenNotification:(NSNotification *)notification{
    if (self.playerViewController.embeddedContentView) {

       // [self.playerViewController.embeddedContentView addSubview:self.playerViewController.view];
        //self.playerViewController.view.frame = self.playerViewController.embeddedContentView.bounds;
    }else{
        [self.playerViewController stop];
        self.playerViewController = nil;
    }
}
@end
