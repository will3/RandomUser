//
//  RandomUserTests.swift
//  RandomUserTests
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import RandomUser

class AppContainerReducerSpec: QuickSpec {
    override func spec() {
        describe("scrollToPage") {
            it("sets page") {
                let state = AppContainer()
                let next = AppContainer.reduce(state: state, event: .scrollToPage(1))
                expect(next.scrollViewPage).to(equal(1))
            }
        }

        describe("loadMore") {
            it("sets trigger") {
                let state = AppContainer()
                let next = AppContainer.reduce(state: state, event: .loadMore)
                expect(next.loadMoreTrigger).to(beTrue())
            }
        }
        
        // etc ...
    }
}
