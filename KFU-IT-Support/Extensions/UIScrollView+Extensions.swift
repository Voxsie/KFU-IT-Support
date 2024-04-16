//
//  UIScrollView+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 14.04.2024.
//

import UIKit

extension UIScrollView {

    /// Scrolls to a subview of the current `UIScrollView `.
    /// - Parameters:
    ///   - view: The subview  to which it should scroll to.
    ///   - position: A constant that identifies a relative position in the `UIScrollView 
    ///   ` (top, middle, bottom) for the subview when scrolling concludes.
    ///   See UITableViewScrollPosition for descriptions of valid constants.
    ///   - animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    func scrollToView(view: UIView,
                      position: UITableView.ScrollPosition = .top,
                      animated: Bool) {

        // Position 'None' should not scroll view to top if visible like in UITableView
        if position == .none &&
            bounds.intersects(view.frame) {
            return
        }

        if let origin = view.superview {
            // Get the subview's start point relative to the current UIScrollView
            let childStartPoint = origin.convert(view.frame.origin,
                                                 to: self)
            var scrollPointY: CGFloat
            switch position {
            case .bottom:
                let childEndY = childStartPoint.y + view.frame.height
                scrollPointY = CGFloat.maximum(childEndY - frame.size.height, 0)
            case .middle:
                let childCenterY = childStartPoint.y + view.frame.height / 2.0
                let scrollViewCenterY = frame.size.height / 2.0
                scrollPointY = CGFloat.maximum(childCenterY - scrollViewCenterY, 0)
            default:
                // Scroll to top
                scrollPointY = childStartPoint.y - 100
            }

            // Scroll to the calculated Y point
            scrollRectToVisible(CGRect(x: 0,
                                       y: scrollPointY,
                                       width: 1,
                                       height: frame.height),
                                animated: animated)
        }
    }

    /// Scrolls to the top of the current `UIScrollView`.
    /// - Parameter animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    /// Scrolls to the bottom of the current `UIScrollView`.
    /// - Parameter animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0,
                                   y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}
