//
//  NKFpsWindow.h
//  TestForCADisplayLink
//
//  Created by Niko on 16/5/25.
//  Copyright © 2016年 niko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKFpsWindow : UIWindow

/**
 *  Singleton Pattern for NKFpsWindow
 *
 *  @return NKFpsWindow
 */
+ (NKFpsWindow *)defaultNFFpsWindow;
@end
