//
//  FlowCoordinator.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit
import SwiftUI

/// simple navigation coordinator for UIKit
protocol FlowCoordinator {
    var rootViewController: UIViewController { get }
}

/// simple navigation coordinator for SwiftUI
protocol SwiftUICoordinator {
    associatedtype RootView: View
    var rootView: RootView { get }
}

final class AppCoordinator: FlowCoordinator {

    var rootViewController: UIViewController {
        LandingCoordinator(configuration: ProcessInfo.isUITest ? MockConfiguration() : Configuration.shared).rootViewController
    }

}
