//
//  EZPlayerViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "EZPlayerViewController.h"

@interface EZPlayerViewController ()
//@property (strong, nonatomic)  NSHashTable *customContentWeakViews;
@property (strong, nonatomic)  UISwipeGestureRecognizer *swipeGestureRecognizer;
@end

@implementation EZPlayerViewController
#pragma mark - ViewControllevr Life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self isViewLoaded]) {
        [self.view.layer removeAllAnimations];
    }
    NSLog(@"%s 释放",__FILE__ );
    
}


#pragma mark - Player action
- (void)loadFromUrl:(NSURL *)url{
    self.playViewController = [[AVPlayerViewController alloc] init];
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:url];
    avPlayer.closedCaptionDisplayEnabled = true;
    //    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.playViewController.player = avPlayer;
    [self.playViewController.player play];
    [self addChildViewController:self.playViewController];
    self.playViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.playViewController.view];
    [self.playViewController didMoveToParentViewController:self];
}


- (void)play{
    [self.playViewController.player play];
}

- (void)pause{
    [self.playViewController.player pause];
}

- (void)stop{
    [self.playViewController.player pause];
    self.playViewController.player = nil;
}

#pragma mark - UIGestureRecognizer methods
- (void)__updateGestureRecognizer{
    if (self.customContentView) {
        if(![self.view.gestureRecognizers containsObject:self.swipeGestureRecognizer]){
            self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
            self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
            [self.view addGestureRecognizer: self.swipeGestureRecognizer];
        }
    }else{
        [self.view removeGestureRecognizer:self.swipeGestureRecognizer];
    }
}

- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)swipeGesture{
    UIGestureRecognizerState state = swipeGesture.state;
    switch (state) {

        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded");
            [self __switchCustomContentViewsShow];
            break;

        default:
            break;
    }
}

#pragma mark - Focus methods


-(UIView *)preferredFocusedView{
    NSLog(@"%s %s",__FILE__,__FUNCTION__);
    if (!self.customContentView.hidden) {
        return self.customContentView;
    }
    return super.preferredFocusedView;
}

- (BOOL)shouldUpdateFocusInContext:(UIFocusUpdateContext *)context{
    NSLog(@"%s %s",__FILE__,__FUNCTION__);
    NSLog(@"nextFocusedView %@",context.nextFocusedView);
    NSLog(@"previouslyFocusedView %@",context.previouslyFocusedView);
    
    
    if (!self.customContentView.hidden) {
        if([NSStringFromClass([context.nextFocusedView class]) isEqualToString:@"_AVFocusContainerView"]){
            return NO;
        }
    }
    return  [super shouldUpdateFocusInContext:context];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
    NSLog(@"%s %s",__FILE__,__FUNCTION__);
    
    [super didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
}



#pragma mark - Public methods


#pragma mark - Private methods
- (void)__switchCustomContentViewsShow{
        if(self.customContentView){
            self.customContentView.hidden = !self.customContentView.hidden;
                if (self.customContentView.hidden) {
                    [self.view sendSubviewToBack:self.customContentView];
                }else{
                    [self.view bringSubviewToFront:self.customContentView];
                }
            [self setNeedsFocusUpdate];
        }
}

#pragma mark - Get／Set methods
-(void)setCustomContentView:(UIView *)customContentView{
    _customContentView = customContentView;
     [self __updateGestureRecognizer];

}

@end
