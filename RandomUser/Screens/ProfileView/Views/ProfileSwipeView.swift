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
    private let numProfileViews = 4
    private var profileViews: [ProfileView] = []
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
    
    var profiles: [User] = []  {
       didSet {
            loading = false
            redraw()
       }
    }

    private func redraw() {
        setupIfNeeded()
        for (i, profileView) in profileViews.enumerated() {
            configureProfileView(profileView, atIndex: i)
        }
    }

    private func configureProfileView(_ profileView: ProfileView, atIndex index: Int) {
        let actualIndex = startIndex + swipeOffset + index
        if actualIndex >= profiles.count {
            profileView.isHidden = true
            return
        }

        profileView.isHidden = false
        let profile = profiles[actualIndex]
        profileView.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
        profileView.addressLabel.text = profile.address
        let age = DateUtils.calcAge(birthday: profile.dob)
        profileView.ageLabel.text = "\(age)"
        let url = profile.thumbImageUrl
        profileView.profileImageView.kf.setImage(with: URL(string: url))
    }

    let insets = UIEdgeInsets(top: 20, left: 20, bottom: 120, right: 20)

    private func setupIfNeeded() {
        if hasSetup {
            return
        }

        createProfileViews()

        addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(handleScreenEdgePan))
        hasSetup = true
    }

    @objc func handleScreenEdgePan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self)
        let profileView = profileViews[0]
        let location = pan.location(in: self)
        let threshold = UIScreen.main.bounds.width *  0.25

        switch pan.state {
        case .began:
            initial = location
            pivot = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.6)
            break
        case .changed:
            let start = atan2(minAbs(initial.y - pivot.y, 20), initial.x - pivot.x)
            let end = atan2(minAbs(initial.y + translation.y * 0.2 - pivot.y, 10), initial.x + translation.x - pivot.x)
            let angular = (end - start) * 0.1

            UIView.animate(withDuration: 0.2) {
                profileView.transform = self.calcTransform(index: 0)
                    .translatedBy(x: translation.x, y: translation.y)
                    .rotated(by: angular)
            }
            
            let gone = pow(max(min(abs(translation.x / threshold), 1), 0), 2)
            
            for i in 1..<numProfileViews {
                let profileView = profileViews[i]
                self.updateProfileView(profileView, index: CGFloat(i) - gone)
            }

            break
        default:
            if (translation.x > threshold) {
                UIView.animate(withDuration: 0.2, animations: {
                    profileView.transform = self.calcTransform(left: false)
                }, completion: { _ in
                    self.onSwipeComplete()
                })
            } else if (translation.x < -threshold) {
                UIView.animate(withDuration: 0.2, animations: {
                    profileView.transform = self.calcTransform(left: true)
                }, completion: { _ in
                    self.onSwipeComplete()
                })
            } else {
                UIView.animate(withDuration: 0.2) {
                    profileView.transform = self.calcTransform(index: 0)
                    
                }
            }

            break
        }
    }
    
    private func onSwipeComplete() {
        let first = profileViews[0]
        for i in 0..<numProfileViews {
            if (i == numProfileViews - 1) {
                profileViews[i] = first
            } else {
                profileViews[i] = profileViews[i + 1]
            }
        }

        swipeOffset += 1

        updateProfileView(first, index: CGFloat(numProfileViews - 1))
        configureProfileView(first, atIndex: profileViews.count - 1)
        
        updateZIndexes()
        
        loadMoreIfNeeded()
    }
    
    
    private func loadMoreIfNeeded() {
        let i = startIndex + swipeOffset
        if (profiles.count - i < loadMoreThreshold) {
            loadMore()
        }
    }

    private func loadMore() {
        if (loading) {
            return
        }

        onLoadMore?()

        loading = true
    }
    
    private func updateZIndexes() {
        for (i, profileView) in profileViews.enumerated() {
            profileView.layer.zPosition = -CGFloat(i)
        }
    }
    
    private func createProfileViews() {
        for _ in 0..<numProfileViews {
            let profileView = ProfileView.fromNib()
            profileViews.append(profileView)
            addSubview(profileView)
            profileView.snp.makeConstraints { make in
                make.edges.equalTo(self).inset(insets)
            }
        }
        
        profileViews.reverse()
        
        updateProfileViews()
    }

    private func updateProfileViews() {
        for (i, profileView) in profileViews.enumerated() {
            updateProfileView(profileView, index: CGFloat(i))
        }
    }
    
    private func updateProfileView(_ profileView: ProfileView, index: CGFloat) {
        profileView.transform = calcTransform(index: index)
        let i = index / (CGFloat(numProfileViews) - 1.0)
        profileView.alpha = 1 - pow(i, 3) * 1.0
    }
    
    private func calcTransform(index: Int) -> CGAffineTransform {
        return calcTransform(index: CGFloat(index))
    }

    private func calcTransform(index: CGFloat) -> CGAffineTransform {
        let i = index / (CGFloat(numProfileViews) - 1.0)

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
        if (abs(val) < absV) {
            if (val < 0) {
                return -absV
            } else {
                return absV
            }
        }
        return val
    }
}
