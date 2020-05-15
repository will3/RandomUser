//
//  ProfileSwipeView+Reactive.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base == ProfileSwipeView {
    var profiles: Binder<[User]> {
        return Binder(base) { view, profiles in
            view.profiles = profiles
        }
    }

    var startIndex: Binder<Int> {
        return Binder(base) { view, startIndex in
            view.startIndex = startIndex
        }
    }

    var nearBottom: Observable<Void> {
        return Observable.create { [weak view = self.base] observer -> Disposable in
            guard let view = view else {
                observer.onCompleted()
                return Disposables.create()
            }

            view.onNearBottom = {
                observer.onNext(())
            }

            return Disposables.create()
        }
    }
}
