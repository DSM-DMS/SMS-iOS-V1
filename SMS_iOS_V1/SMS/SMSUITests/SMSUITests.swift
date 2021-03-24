//
//  SMSUITests.swift
//  SMSUITests
//
//  Created by 이현욱 on 2021/03/18.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import XCTest

class SMSUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func test_SearchUserResultAvailable() {
    
        
//        let app = XCUIApplication()
//                app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page").children(matching: .cell).element(boundBy: 1).children(matching: .other).element.tap()
//        let collectionViewsQuery = app.collectionViews
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["back"]/*[[".cells.buttons[\"back\"]",".buttons[\"back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["외출 사유를 입력해주세요"]/*[[".cells.textFields[\"외출 사유를 입력해주세요\"]",".textFields[\"외출 사유를 입력해주세요\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
