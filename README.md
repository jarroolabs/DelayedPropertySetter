# DelayedPropertySetter

Utility wrapper that delays property-setting operations until the wrapped value is set.

Useful for situations where a value is initialized at a later time (e.g. `viewDidLoad`, `@IBOutlet`), 
while its properties can (or should) be set a different (possibly earlier) time, controlled by some animation or user
action (e.g. changing a controller's `additionalSafeAreaInsets` before the controller has been lazily initialized).

## Example usage

```swift
let childController = DelayedPropertySetter<UIViewController>()

func set(newChildController: MenuContentController) {
    self.childController.set(to: newChildController)
    addChild(newChildController)
    // ...
}
 
func update(accessoryViewHeight: CGFloat, animated: Bool) {
    childController.setProperty(
        \.additionalSafeAreaInsets,
        to: UIEdgeInsets(top: 0, left: 0, bottom: accessoryViewHeight, right: 0)
    )
    // ...
}
```

The child controller's `additionalSafeAreaInsets` would still be set, even though `update(accessoryViewHeight:animated)` might get called before the `childController` variable is set. 
