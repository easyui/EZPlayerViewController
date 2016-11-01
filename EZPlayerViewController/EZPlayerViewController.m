//
//  EZPlayerViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/8/8.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "EZPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>


// AVPlayerItem's status property
#define STATUS_KEYPATH @"status"
// Define this constant for the key-value observation context.
static const NSString *PlayerItemStatusContext;

@interface EZPlayerViewController ()
//@property (strong, nonatomic)  AVPlayer *avPlayer;
@property (strong, nonatomic) AVAsset *asset;
@property (strong, nonatomic) AVPlayerItem *playerItem;


@property (strong, nonatomic)  UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (strong, nonatomic)  UITapGestureRecognizer *tapMenuGestureRecognizer;

@property (assign, nonatomic)  BOOL isInterceptedMenu;


@property (strong, nonatomic) id itemEndObserver;

@property (strong, nonatomic) NSURL * url;

@end

@implementation EZPlayerViewController
#pragma mark - ViewControllevr Life

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)assetURL{
    if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.url = assetURL;
        self.asset = [AVAsset assetWithURL:assetURL];
        [self __prepareToPlay];
    }
    return self;
    
}



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
    NSLog(@"%s ",__FILE__ );
    if (self.itemEndObserver) {                                             // 5
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.itemEndObserver
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:self.playerItem];
        self.itemEndObserver = nil;
    }
}


#pragma mark - Player action
- (void)playWithURL:(NSURL *)assetURL{
    if (!assetURL) {
        return;
    }
    self.url = assetURL;
    self.asset = [AVAsset assetWithURL:assetURL];
    [self __prepareToPlay];
    [self play];
}

- (void)play{
    [self.playViewController.player play];
}

- (void)pause{
    [self.playViewController.player pause];
}

- (void)seekToTime:(float)seconds{
    [self seekToTime:seconds completionHandler:nil];
}

- (void)seekToTime:(float)seconds completionHandler:(void (^)(BOOL finished))completionHandler{
    [self.playViewController.player.currentItem cancelPendingSeeks];
    [self.playViewController.player seekToTime:CMTimeMakeWithSeconds(seconds, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}



- (void)stop{
    [self.playViewController.player pause];
    self.playViewController.player = nil;
}

- (BOOL)isPlaying{
    return (self.playViewController.player && self.self.playViewController.player.rate != 0.0);
}

- (NSTimeInterval)currentTime{
    return CMTimeGetSeconds([self.playViewController.player currentTime]);
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
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.embeddedContentView) {
                    [self.embeddedContentView addSubview:self.view];
                    self.view.frame = self.embeddedContentView.bounds;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:EZPlayerViewControllerExitFullScreenNotification object:nil];
                
            }];
            
            
        });
    }
}


#pragma mark - Focus methods


-(UIView *)preferredFocusedView{
    if (!self.customContentView.hidden) {
        return self.customContentView;
    }
    return super.preferredFocusedView;
}

- (BOOL)shouldUpdateFocusInContext:(UIFocusUpdateContext *)context{
    if (!self.customContentView.hidden) {
        if([NSStringFromClass([context.nextFocusedView class]) isEqualToString:@"_AVFocusContainerView"]){
            return NO;
        }
    }
    return  [super shouldUpdateFocusInContext:context];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
    
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


- (void)__prepareToPlay {
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self
                      forKeyPath:STATUS_KEYPATH
                         options:0
                         context:&PlayerItemStatusContext];
    
    AVPlayer *avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self __configAVPlayerViewController];
    avPlayer.closedCaptionDisplayEnabled = YES;
    self.playViewController.player = avPlayer;
    [self __updatePlayerInfo];
    
    
}

- (void)__addItemEndObserverForPlayerItem {
    
    NSString *name = AVPlayerItemDidPlayToEndTimeNotification;
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // __weak EZPlayerViewController *weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EZPlayerViewControllerDidPlayToEndTimeNotification object:nil];
        
    };
    
    self.itemEndObserver =
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:self.playerItem
                                                       queue:queue
                                                  usingBlock:callback];
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

#pragma mark - Get／Set methods
-(void)setIsCustomContentViewHidden:(BOOL)isCustomContentViewHidden{
    _isCustomContentViewHidden = isCustomContentViewHidden;
    if(self.customContentView){
        [self playViewController:self handleCustomContentView:self.customContentView isHidden:isCustomContentViewHidden completionHandler:^{
            [self setNeedsFocusUpdate];
        }];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == &PlayerItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                [self __addItemEndObserverForPlayerItem];
            } else {
                // todo
            }
        });
    }
}



@end
