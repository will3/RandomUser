//
//  NetworkStatusImpl.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import Reachability

class NetworkStatusImpl: NetworkStatus {
    private let reachability: Reachability
    init(reachability: Reachability) {
        self.reachability = reachability
    }
    
    var isDisconnected: Bool {
        return reachability.connection == .unavailable
    }
}
