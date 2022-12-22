//
//  UIButton+combine.swift
//  GithubScrapper
//
//  Created by Nikita Rodin on 12.11.22.
//

import UIKit
import Combine

extension UIControl {
    /// addTarget wrapper as combine subscription
    private final class ControlEventSubscription<S: Subscriber>: Subscription where S.Input == Void {

        private var subscriber: S?
        private weak var control: UIControl?

        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control

            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        @objc func eventHandler(_ sender: UIControl) {
            _ = subscriber?.receive(())
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }
    }

    /// uses addTarget subscription above to emit control events
    private struct ControlEvent: Publisher {
        typealias Output = Void
        typealias Failure = Never

        fileprivate let control: UIControl
        fileprivate let event: UIControl.Event

        func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = ControlEventSubscription(subscriber: subscriber,
                                                        control: control,
                                                        event: event)
            subscriber.receive(subscription: subscription)
        }
    }

    /// exposes type-erased publisher for control events
    /// - Parameter event: control event
    /// - Returns: publisher
    func controlEventPublisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        ControlEvent(control: self, event: event)
            .eraseToAnyPublisher()
    }
}

extension UIButton {

    /// touchUpInside publisher
    var tapped: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
    }

}
