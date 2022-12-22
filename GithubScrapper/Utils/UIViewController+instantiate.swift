//
//  UIViewController+instantiate.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit

/// instantate from storyboard
extension UIViewController {
    class func instantiate() -> Self {
        UIStoryboard.main.instantiateViewController(withIdentifier: className) as! Self
    }
}
extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
