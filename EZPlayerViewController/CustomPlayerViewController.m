//
//  CustomPlayerViewController.m
//  EZPlayerViewController
//
//  Created by yangjun zhu on 2016/10/19.
//  Copyright © 2016年 yangjun zhu. All rights reserved.
//

#import "CustomPlayerViewController.h"
#import "EZPlayerViewController.h"
//@interface NSTimer (EZ_Helper)
//+ (NSTimer *)ez_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
//+ (NSTimer *)ez_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
//@end
//
//@implementation NSTimer (EZ_Helper)
//+ (NSTimer *)ez_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
//{
//    void (^block)() = [inBlock copy];
//    NSTimer * timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
//    return timer;
//}
//
//+ (NSTimer *)ez_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
//{
//    void (^block)() = [inBlock copy];
//    NSTimer * timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
//    return timer;
//}
//
//+ (void)__executeTimerBlock:(NSTimer *)inTimer;
//{
//    if([inTimer userInfo])
//    {
//        void (^block)() = (void (^)())[inTimer userInfo];
//        block();
//    }
//}
//@end


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
    // Do any additional setup after loading the view.
//    if(self.updatePlayerTimer){
//        [self.updatePlayerTimer invalidate];
//        self.updatePlayerTimer = nil;
//    }
//    self.updatePlayerTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
//                                                       target:self
//                                                     selector:@selector(updatePlayer)  userInfo:nil
//                                                      repeats:YES];
    
//    self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    self.swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.view addGestureRecognizer: self.swipeRecognizer];
   
}

//
//-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
//    
//    //如果往左滑
//    NSLog(@"111111111111111");
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//        
//        NSLog(@"111111111111111______");
//
//        self.customView.hidden = !self.customView.hidden;
//        if (self.customView.hidden) {
//                [self.view sendSubviewToBack:self.customView];
//
//        }else{
//            [self.view bringSubviewToFront:self.customView];
//
//        
//        }
//        [self setNeedsFocusUpdate];
//    }
//    
//
//    
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"___%@",self.avNowPlayingTransportBarPoint);
//    [self.avNowPlayingTransportBarPoint addObserver:self forKeyPath:@"hidden" options:0 context:nil];
//    [self.avNowPlayingTransportBarPoint addObserver:self forKeyPath:@"alpha" options:0 context:nil];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
//    [self.avNowPlayingTransportBarPoint removeObserver:self forKeyPath:@"hidden"];
//    [self.updatePlayerTimer invalidate];
//    self.updatePlayerTimer = nil;


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//- (UIView *)__avNowPlayingTransportBar{
//    [self __findSubViewClass:@"AVNowPlayingTransportBar" from:self.playViewController.view];
//}

//- (UIView *)avNowPlayingTransportBarPoint{
//    if (!_avNowPlayingTransportBarPoint) {
//        _avNowPlayingTransportBarPoint =  [self __findSubViewClass:@"AVNowPlayingTransportBar" from:self.playViewController.view];
//    }
//    return _avNowPlayingTransportBarPoint;
//}


//if ([NSStringFromClass([subView class]) isEqualToString:@"AVNowPlayingTransportBar"]){

//-(UIView *)__findSubViewClass:(NSString*)classString from:(UIView *) view
//{
//    for (UIView* subView in view.subviews)
//    {
//        if ([NSStringFromClass([subView class]) isEqualToString:classString]){
//            return subView;
//        }
//        UIView* controlBarView = [self __findSubViewClass:classString from:subView];
//        if (controlBarView) {
//            return controlBarView;
//        };
//    }
//    return nil;
//}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                        change:(NSDictionary *)change context:(void *)context  {
//    NSLog(@"sssssss");
//    if ([keyPath isEqualToString:@"hidden"] && object == self.avNowPlayingTransportBarPoint.superview ) {
//        
//        self.customView.hidden = self.avNowPlayingTransportBarPoint.hidden;
//        if (self.avNowPlayingTransportBarPoint.hidden ){
//            [self.view sendSubviewToBack:self.customView];
//
//        }else{
//            [self.view bringSubviewToFront:self.customView];
//        }
//        
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context: context];
//    }
//    
//}

//- (void)updatePlayer{
//    UIView* controlBarView = self.avNowPlayingTransportBarPoint;
////    if (!controlBarView || controlBarView.superview.hidden ||controlBarView.alpha == 0.0) {
//    if (controlBarView.hidden ) {
//
//         [self.view sendSubviewToBack:self.customView];
//    }else{
//         [self.view bringSubviewToFront:self.customView];
//    }
//
//}

@end
