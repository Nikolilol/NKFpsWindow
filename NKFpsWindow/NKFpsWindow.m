//
//  NKFpsWindow.m
//  TestForCADisplayLink
//
//  Created by Niko on 16/5/25.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "NKFpsWindow.h"

@interface NKFpsWindow (){
    NSUInteger _count;
    NSTimeInterval _lastTime;
}
@property(nonatomic, weak) CATextLayer *fpsTextLayer;
@property(nonatomic, weak) CADisplayLink *displayLink;
@end

@implementation NKFpsWindow

- (void)dealloc
{
    [_displayLink invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - init
+ (NKFpsWindow *)defaultNKFpsWindow{
    static NKFpsWindow *_defaultNKFpsWindow;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultNKFpsWindow = [[NKFpsWindow alloc] init];
        if([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
            _defaultNKFpsWindow.rootViewController = [UIViewController new]; // iOS 9 requires rootViewController for any window
    });
    return _defaultNKFpsWindow;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(10.0f, 20.0f, 100.0f, 20.0f)];
    if (self) {
        
        [self setWindowLevel: UIWindowLevelStatusBar +1.0f];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];

        
        // Configuration UI
        CATextLayer *fpsTextLayer = [CATextLayer layer];
        [fpsTextLayer setFrame:self.bounds];
        [fpsTextLayer setFontSize: 20.0f];
        [fpsTextLayer setForegroundColor: [UIColor redColor].CGColor];
        [fpsTextLayer setContentsScale: [UIScreen mainScreen].scale];
        [self.layer addSublayer:fpsTextLayer];
        _fpsTextLayer = fpsTextLayer;
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkRun:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = displayLink;
    }
    return self;
}

# pragma mark - CADisplayLink Method
- (void)linkRun:(CADisplayLink *)link{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;  //refresh rate for each frame display
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSString *fpsStr = [NSString stringWithFormat:@"%f", fps];
    int fpsInt = [fpsStr intValue];
    [_fpsTextLayer setString:[NSString stringWithFormat:@"%d FPS", fpsInt]];
}

# pragma mark - NSNotification Method
- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}

@end
