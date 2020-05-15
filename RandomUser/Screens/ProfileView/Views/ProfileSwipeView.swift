//
//  ProfileSwipeView.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import UIKit

class ProfileSwipeView: UIView {
    private let numCards = 4
    private var cards: [ProfileCardView] = []
    private var hasSetup = false
    private let pan = UIPanGestureRecognizer()
    private var initial = CGPoint()
    private var pivot = CGPoint()
    private let loadMoreThreshold = 4
    private var loading = false

    var onLoadMore: (() -> Void)?

    var swipeOffset = 0

    var startIndex: Int = 0 {
        didSet {
            redraw()
        }
    }

    var profiles: [User] = [] {
        didSet {
            loading = false
            redraw()
        }
    }

    private func redraw() {
        setupIfNeeded()
        for (i, card) in cards.enumerated() {
            configureCard(card, atIndex: i)
        }
    }

    private func configureCard(_ card: ProfileCardView, atIndex index: Int) {
        let actualIndex = startIndex + swipeOffset + index
        if actualIndex >= profiles.count {
            card.isHidden = true
            return
        }

        card.isHidden = false
        let profile = profiles[actualIndex]
        card.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
        card.addressLabel.text = profile.address
        let age = DateUtils.calcAge(birthday: profile.dob)
        card.ageLabel.text = "\(age)"
        let url = profile.thumbImageUrl
        card.profileImageView.kf.setImage(with: URL(string: url))
    }

    let insets = UIEdgeInsets(top: 20, left: 20, bottom: 120, right: 20)

    private func setupIfNeeded() {
        if hasSetup {
            return
        }

        createCards()

        addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(handleScreenEdgePan))
        hasSetup = true
    }

    @objc func handleScreenEdgePan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self)
        let card = cards[0]
        let location = pan.location(in: self)
        let threshold = UIScreen.main.bounds.width * 0.25

        switch pan.state {
        case .began:
            initial = location
            pivot = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.6)
        case .changed:
            let start = atan2(minAbs(initial.y - pivot.y, 20), initial.x - pivot.x)
            let end = atan2(minAbs(initial.y + translation.y * 0.2 - pivot.y, 10), initial.x + translation.x - pivot.x)
            let angular = (end - start) * 0.1

            UIView.animate(withDuration: 0.2) {
                card.transform = self.calcTransform(index: 0)
                    .translatedBy(x: translation.x, y: translation.y)
                    .rotated(by: angular)
            }

            let gone = pow(max(min(abs(translation.x / threshold), 1), 0), 2)

            for i in 1 ..< numCards {
                let card = cards[i]
                updateCard(card, index: CGFloat(i) - gone)
            }

        default:
            if translation.x > threshold {
                UIView.animate(withDuration: 0.2, animations: {
                    card.transform = self.calcTransform(left: false)
                }, completion: { _ in
                    self.onSwipeComplete()
                })
            } else if translation.x < -threshold {
                UIView.animate(withDuration: 0.2, animations: {
                    card.transform = self.calcTransform(left: true)
                }, completion: { _ in
                    self.onSwipeComplete()
                })
            } else {
                UIView.animate(withDuration: 0.2) {
                    card.transform = self.calcTransform(index: 0)
                }
            }
        }
    }

    private func onSwipeComplete() {
        let first = cards[0]
        for i in 0 ..< numCards {
            if i == numCards - 1 {
                cards[i] = first
            } else {
                cards[i] = cards[i + 1]
            }
        }

        swipeOffset += 1

        updateCard(first, index: CGFloat(numCards - 1))
        configureCard(first, atIndex: cards.count - 1)

        updateZIndexes()

        loadMoreIfNeeded()
    }

    private func loadMoreIfNeeded() {
        let i = startIndex + swipeOffset
        if profiles.count - i < loadMoreThreshold {
            loadMore()
        }
    }

    private func loadMore() {
        if loading {
            return
        }

        onLoadMore?()

        loading = true
    }

    private func updateZIndexes() {
        for (i, card) in cards.enumerated() {
            card.layer.zPosition = -CGFloat(i)
        }
    }

    private func createCards() {
        for _ in 0 ..< numCards {
            let card = ProfileCardView.fromNib()
            cards.append(card)
            addSubview(card)
            card.snp.makeConstraints { make in
                make.edges.equalTo(self).inset(insets)
            }
        }

        cards.reverse()

        updateCards()
    }

    private func updateCards() {
        for (i, card) in cards.enumerated() {
            updateCard(card, index: CGFloat(i))
        }
    }

    private func updateCard(_ card: ProfileCardView, index: CGFloat) {
        card.transform = calcTransform(index: index)
        let i = index / (CGFloat(numCards) - 1.0)
        card.alpha = 1 - pow(i, 3) * 1.0
    }

    private func calcTransform(index: Int) -> CGAffineTransform {
        return calcTransform(index: CGFloat(index))
    }

    private func calcTransform(index: CGFloat) -> CGAffineTransform {
        let i = index / (CGFloat(numCards) - 1.0)

        let scale: CGFloat = 1.0 - pow(i, 1) * 0.08
        let translateY: CGFloat = pow(i, 1) * 64.0

        return CGAffineTransform.identity
            .translatedBy(x: 0, y: translateY)
            .scaledBy(x: scale, y: scale)
    }

    private func calcTransform(left: Bool) -> CGAffineTransform {
        let x = UIScreen.main.bounds.width * 1.1
        let y = UIScreen.main.bounds.height * 0.2
        return calcTransform(index: 0)
            .translatedBy(x: left ? -x : x, y: y)
            .rotated(by: left ? -0.1 : 0.1)
    }

    private func minAbs(_ val: CGFloat, _ absV: CGFloat) -> CGFloat {
        if abs(val) < absV {
            if val < 0 {
                return -absV
            } else {
                return absV
            }
        }
        return val
    }
}
