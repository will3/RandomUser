//
//  ProfileSwipeView+Reactive.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base == ProfileSwipeView {
    var profiles: Binder<[User]> {
        return Binder(self.base) { view, profiles in
            view.profiles = profiles
        }
    }

    var startIndex: Binder<Int> {
        return Binder(self.base) { view, startIndex in
            view.startIndex = startIndex
        }
    }

    var loadMore: Observable<ProfileSwipeView> {
        return Observable.create { [weak view = self.base] observer -> Disposable in
            guard let view = view else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            view.onLoadMore = { [weak view] in
                if let view = view {
                    observer.onNext(view)
                }
            }
            
            return Disposables.create()
        }
    }
}
