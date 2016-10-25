//
//  EZPlayerViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "EZPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface EZPlayerViewController ()
//@property (strong, nonatomic)  AVPlayer *avPlayer;


@property (strong, nonatomic)  UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (strong, nonatomic)  UITapGestureRecognizer *tapMenuGestureRecognizer;

@property (assign, nonatomic)  BOOL isInterceptedMenu;



@end

@implementation EZPlayerViewController
#pragma mark - ViewControllevr Life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCustomContentViewHidden = YES;
    [self __addTapMenuGestureRecognizer];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self isViewLoaded]) {
        [self.view.layer removeAllAnimations];
    }
    NSLog(@"%s 释放",__FILE__ );
    
}


#pragma mark - Player action
- (void)playWithURL:(NSURL *)url{
    if (!url) {
        return;
    }
    self.url = url;
    [self play];
}

- (void)play{
    if (self.url && !self.playViewController) {
        [self __configAVPlayerViewController];
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:self.url];
        avPlayer.closedCaptionDisplayEnabled = YES;
        self.playViewController.player = avPlayer;
        [self __updatePlayerInfo];
        
    }
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
            NSLog(@"%@",self.preferredFocusedView);
            if (self.customContentView && self.customContentView.hidden) {
                [self __switchCustomContentViewsShow];
            }
            break;
            
        default:
            break;
    }
}

- (void)__addTapMenuGestureRecognizer{
    [self.view removeGestureRecognizer:self.tapMenuGestureRecognizer];
    self.tapMenuGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuGestureRecognized:)];
    self.tapMenuGestureRecognizer.allowedPressTypes = @[@(UIPressTypeMenu)];
    [self.view addGestureRecognizer:self.tapMenuGestureRecognizer];
}

- (void)tapMenuGestureRecognized:(UITapGestureRecognizer *)tapMenuGesture{
    if(!self.isCustomContentViewHidden){
        [self __switchCustomContentViewsShow];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EZPlayerViewControllerExitFullScreenNotification object:nil];
            
        }];
    }
    //    [self.view removeGestureRecognizer:self.tapMenuGestureRecognizer];
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


#pragma mark - Touch methods
/*
 -(void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
 
 self.isInterceptedMenu = NO;;
 
 if ( presses.anyObject.type == UIPressTypeMenu) {
 if (!self.customContentView || self.customContentView.hidden ) {
 [[NSNotificationCenter defaultCenter] postNotificationName:EZPlayerViewControllerExitFullScreenNotification object:nil];
 self.isInterceptedMenu = YES;
 return;
 }
 }
 
 [super pressesBegan:presses withEvent:event];
 }
 
 -(void)pressesChanged:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
 
 if ( presses.anyObject.type == UIPressTypeMenu && self.isInterceptedMenu) {
 return;
 }
 
 [super pressesChanged:presses withEvent:event];
 }
 
 -(void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
 
 if ( presses.anyObject.type == UIPressTypeMenu && self.isInterceptedMenu) {
 return;
 }
 
 [super pressesEnded:presses withEvent:event];
 }
 
 
 -(void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
 if ( presses.anyObject.type == UIPressTypeMenu && self.isInterceptedMenu) {
 
 return;
 }
 
 [super pressesCancelled:presses withEvent:event];
 }
 
 */
#pragma mark - Public methods
- (void)playViewController:(EZPlayerViewController *)playViewController handleCustomContentView:(UIView *)customContentView isHidden:(BOOL)isHidden completionHandler:(void(^)())completionHandler{
    self.customContentView.hidden = isHidden;
    if (self.customContentView.hidden) {
        [self.view sendSubviewToBack:self.customContentView];
    }else{
        [self.view bringSubviewToFront:self.customContentView];
    }
    completionHandler();
}


#pragma mark - Private methods
- (void)__switchCustomContentViewsShow{
    self.isCustomContentViewHidden = !self.isCustomContentViewHidden;
}


- (void)__configAVPlayerViewController{
    if (!self.playViewController) {
        self.playViewController = [[AVPlayerViewController alloc] init];
        [self addChildViewController:self.playViewController];
        self.playViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.playViewController.view];
        [self.playViewController didMoveToParentViewController:self];
    }
}

- (void)__updatePlayerInfo{
    if(self.playViewController.player){
        NSMutableArray<AVMetadataItem *>* metadataItems = [[NSMutableArray alloc] initWithCapacity:2];
        if (self.playerTitle) {
            [metadataItems addObject:[self __createMetadataItemWithIdentifier:AVMetadataCommonIdentifierTitle value:self.playerTitle]];
        }
        if (self.playerDescription) {
            [metadataItems addObject:[self __createMetadataItemWithIdentifier:AVMetadataCommonIdentifierDescription value:self.playerDescription]];
        }
        self.playViewController.player.currentItem.externalMetadata = metadataItems;
    }
    
}

- (AVMetadataItem *)__createMetadataItemWithIdentifier:(NSString *)identifier value:(NSString *)value{
    AVMutableMetadataItem * metaDataItem =  [[AVMutableMetadataItem alloc] init];
    metaDataItem.identifier = identifier;
    metaDataItem.value = value;
    metaDataItem.locale = NSLocale.autoupdatingCurrentLocale;
    return metaDataItem;
}

#pragma mark - Get／Set methods
-(void)setCustomContentView:(UIView *)customContentView{
    _customContentView = customContentView;
    [self __updateGestureRecognizer];
}

-(void)setPlayerTitle:(NSString *)playerTitle{
    _playerTitle = playerTitle;
    [self __updatePlayerInfo];
}

-(void)setPlayerDescription:(NSString *)playerDescription{
    _playerDescription = playerDescription;
    [self __updatePlayerInfo];
}

-(void)setIsCustomContentViewHidden:(BOOL)isCustomContentViewHidden{
    _isCustomContentViewHidden = isCustomContentViewHidden;
    if(self.customContentView){
        [self playViewController:self handleCustomContentView:self.customContentView isHidden:isCustomContentViewHidden completionHandler:^{
            if (!isCustomContentViewHidden) {
                //                [self __addTapMenuGestureRecognizer];
            }
            [self setNeedsFocusUpdate];
            
        }];
    }
    
}

@end
