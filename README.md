# NKFpsWindow
Show fps in DEBUG on iOS App Screen 

## How to use
- Download NKFpsWindow and Copy group NKFpsWindow to your OC project.

```C
import "NKFpsWindow.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    #ifdef DEBUG
    [[NKFpsWindow defaultNKFpsWindow] setHidden:NO];
    #endif
    return YES;
  }
```

## License

NKFpsWindow is released under the MIT license. See LICENSE for details.
