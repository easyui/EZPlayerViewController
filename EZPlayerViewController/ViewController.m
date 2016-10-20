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
    self.playerViewController = [[CustomPlayerViewController alloc] initWithNibName:@"CustomPlayerViewController" bundle:nil];
    [self.playerViewController loadFromUrl:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    [self presentViewController:self.playerViewController animated:YES completion:nil];

}

@end
