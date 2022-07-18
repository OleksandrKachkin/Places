//
//  UIImageView+Extension.swift
//  Places
//
//  Created by Oleksandr Kachkin on 18.07.2022.
//

import UIKit

extension UIImageView {
  
  func applyBlurEffect() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
  
  func removeBlurEffect() {
    let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
    blurredEffectViews.forEach{ blurView in
      blurView.removeFromSuperview()
    }
  }

}
