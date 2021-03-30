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
        
        let app = XCUIApplication()
         setupSnapshot(app)
         app.launch()


        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func test_SearchUserResultAvailable() {
        
        let app = XCUIApplication()
        addUIInterruptionMonitor(withDescription: "Allow push") { (alerts) -> Bool in
                    if(alerts.buttons["Allow"].exists){
                        alerts.buttons["Allow"].tap();
                    }
                    return true;
                }
        let idText = app.textFields["아이디를 입력해주세요"]
        idText.tap()
        idText.typeText("student1")
        let pwText = app.secureTextFields["비밀번호를 입력해주세요"]
        pwText.tap()
        pwText.typeText("student1")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["로그인"].tap()
        snapshot("Schedule")
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.children(matching: .button).element(boundBy: 1).tap()
        snapshot("Outing")
        tabBar.children(matching: .button).element(boundBy: 2).tap()
        snapshot("Notice")
        tabBar.children(matching: .button).element(boundBy: 3).tap()
        snapshot("MyPage")
               
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
