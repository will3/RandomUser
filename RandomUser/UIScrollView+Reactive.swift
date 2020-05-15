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
            .flatMap({ (offset) -> Signal<Int> in
                let exactPage = self.base.contentOffset.x / self.base.bounds.size.width
                let page = floor(exactPage)
                return (exactPage - page < 0.1)
                    ? Signal.just(Int(page))
                    : Signal.empty()
            })
            .distinctUntilChanged()
    }
}
