# Refreshment
* Pull to refresh.
* Support top left bottom right direction.
* Support auto layout.

# Usage
1. Create custom refresh view extends RefreshmentView.
2. Used as follow code.

```swift
    CustomRefreshmentView *view = [[CustomRefreshmentView alloc] init];
    view.trigger = ^(HorizontalRefreshView * view) {
        // refresh code        
    };
    tableView.rf.top = view;
```
