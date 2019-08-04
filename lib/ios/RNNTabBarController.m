#import "RNNTabBarController.h"

@implementation RNNTabBarController {
	NSUInteger _currentTabIndex;
	NSIndexSet* _ignoredRetapIndexs;
	BOOL _shouldIgnore;
}

- (id<UITabBarControllerDelegate>)delegate {
	return self;
}

- (void)viewDidLayoutSubviews {
	[self.presenter viewDidLayoutSubviews];
}

- (UIViewController *)getCurrentChild {
	return self.selectedViewController;
}

- (CGFloat)getTopBarHeight {
    for(UIViewController * child in [self childViewControllers]) {
        CGFloat childTopBarHeight = [child getTopBarHeight];
        if (childTopBarHeight > 0) return childTopBarHeight;
    }
    return [super getTopBarHeight];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return self.selectedViewController.supportedInterfaceOrientations;
}

- (void)setSelectedIndexByComponentID:(NSString *)componentID {
	for (id child in self.childViewControllers) {
		UIViewController<RNNLayoutProtocol>* vc = child;

		if ([vc conformsToProtocol:@protocol(RNNLayoutProtocol)] && [vc.layoutInfo.componentId isEqualToString:componentID]) {
			[self setSelectedIndex:[self.childViewControllers indexOfObject:child]];
		}
	}
}
- (void)forceSelectedIndex:(NSInteger) index{
	_shouldIgnore = false;
	[self setSelectedIndex: index];
}

- (void)forceSelectedIndexByComponentID:(NSString *)componentID{
	_shouldIgnore = false;
	[self setSelectedIndexByComponentID:componentID];
}

- (void)setIgnoredRetapOnItemIndexs:(NSIndexSet *)indexs {
	_ignoredRetapIndexs = indexs;
	_shouldIgnore = false;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	_currentTabIndex = selectedIndex;
	[super setSelectedIndex:selectedIndex];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[self.eventEmitter sendBottomTabSelected:@(tabBarController.selectedIndex) unselected:@(_currentTabIndex)];
	_currentTabIndex = tabBarController.selectedIndex;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
	if (_ignoredRetapIndexs != nil && _ignoredRetapIndexs.count == 0) {
		return true;
	}
	NSInteger selectingIndex = [tabBarController.viewControllers indexOfObject:viewController];
	if (tabBarController.selectedIndex == selectingIndex && [_ignoredRetapIndexs containsIndex:selectingIndex]){
		if (_shouldIgnore) {
			[self.eventEmitter sendBottomTabShouldRetap: @(selectingIndex)];
			return false;
		}else {
			_shouldIgnore = true;
			return true;
		}
	}
	return true;
}

@end
