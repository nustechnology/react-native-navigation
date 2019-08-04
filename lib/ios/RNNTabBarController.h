#import <UIKit/UIKit.h>
#import "RNNEventEmitter.h"
#import "RNNTabBarPresenter.h"
#import "UIViewController+LayoutProtocol.h"

@interface RNNTabBarController : UITabBarController <RNNLayoutProtocol, UITabBarControllerDelegate>

- (void)setSelectedIndexByComponentID:(NSString *)componentID;

- (void)setIgnoredRetapOnItemIndexs:(NSIndexSet *)indexs;

- (void)forceSelectedIndex:(NSInteger) index;

- (void)forceSelectedIndexByComponentID:(NSString *)componentID;

@end
