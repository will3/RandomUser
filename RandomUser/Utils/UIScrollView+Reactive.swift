//
//  UIScrollView+Reactive.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    var didScrollToExactPage: Signal<Int> {
        base.rx.didEndDecelerating
            .asSignal(onErrorSignalWith: .empty())
            .flatMap { [weak view = self.base] (_) -> Signal<Int> in
                guard let view = view else { return Signal.empty() }
                let exactPage = view.contentOffset.x / view.bounds.size.width
                let page = floor(exactPage)
                return (exactPage - page < 0.1)
                    ? Signal.just(Int(page))
                    : Signal.empty()
            }
            .distinctUntilChanged()
    }

    var nearBottom: Signal<Void> {
        base.rx.contentOffset.asDriver().flatMap { [weak view = self.base] _ in
            guard let view = view else { return Signal.empty() }
            return view.isNearBottomEdge() ? Signal.just(()) : Signal.empty()
        }
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 200.0) -> Bool {
        return contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }
}
