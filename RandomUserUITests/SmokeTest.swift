//
//  RandomUserUITests.swift
//  RandomUserUITests
//
//  Created by will on 13/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import XCTest
import Quick
import Nimble

class SmokeTestSpec: QuickSpec {
    override func spec() {
        it("demo") {
            let app = XCUIApplication()
            app.launch()
            
            let _ = HomePage(app: app)
                .scrollDown()
                .scrollDown()
                .scrollDown()
                .scrollDown()
                .openFilter()
                .toggleKitten()
                .done()
                .scrollDown()
                .openProfile()
                .swipeRight()
                .swipeLeft()
                .swipeRight()
                .swipeLeft()
                .swipeRight()
                .swipeLeft()
        }
    }
}

class Page {
    let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }
}

class HomePage: Page {
    func scrollDown() -> HomePage {
        app.swipeUp()
        return self
    }

    func openProfile() -> SwipePage {
        app.cells.firstMatch.tap()
        return SwipePage(app: app)
    }
    
    func openFilter() -> FilterPage {
        app.buttons.matching(identifier: AccessibilityIdentifiers.filterButton).firstMatch.tap()
        return FilterPage(app: app)
    }
}

class SwipePage: Page {
    func swipeLeft() -> SwipePage {
        app.swipeLeft()
        return self
    }
    
    func swipeRight() -> SwipePage {
        app.swipeRight()
        return self
    }
    
    func gotoHome() -> HomePage {
        app.buttons.matching(identifier: AccessibilityIdentifiers.listViewButton)
            .firstMatch.tap()
        return HomePage(app: app)
    }
}

class FilterPage: Page {
    func toggleKitten() -> FilterPage {
        let table = app.tables.element(boundBy: 1)
        table.cells.element(boundBy: 2).tap()
        return self
    }
    
    func done() -> HomePage {
        app.buttons.matching(identifier: AccessibilityIdentifiers.doneButton).firstMatch.tap()
        return HomePage(app: app)
    }
}
