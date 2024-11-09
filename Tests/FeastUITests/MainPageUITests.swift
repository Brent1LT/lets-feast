import XCTest

final class MainPageUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testAllElementsRender() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        // Check for header
        let settingsPageButton = app.images["Profile Settings"]
        XCTAssertTrue(settingsPageButton.exists)
        // Check for filters
        let filterShow = app.buttons["Show Filters"]
        XCTAssertTrue(filterShow.exists)
        // Check for search
        let searchButton = app.buttons["Search for restaurants"]
        XCTAssertTrue(searchButton.exists)
        // Check for map
        let locatorButton = app.buttons["Tracking"]
        XCTAssertTrue(locatorButton.exists)
        locatorButton.tap()
        // Check for Restaurant ScrollView
        let scrollViewItem = app.scrollViews.otherElements.staticTexts["Sushi Palace"]
        XCTAssertTrue(scrollViewItem.exists)
                
//        let app = XCUIApplication()
//        app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"VKPointFeature").element/*[[".maps.containing(.other, identifier:\"Bret Harte\").element",".maps.containing(.other, identifier:\"San Joaquin River National Wildlife Refuge\").element",".maps.containing(.other, identifier:\"Empire\").element",".maps.containing(.other, identifier:\"Outback Steakhouse (5 mins), Outback Steakhouse (5 mins), Outback Steakhouse (5 mins)\").element",".maps.containing(.other, identifier:\"Starbucks, Starbucks, Starbucks\").element",".maps.containing(.other, identifier:\"Olive Garden Italian Restaurant, Olive Garden Italian Restaurant, Olive Garden Italian Restaurant\").element",".maps.containing(.other, identifier:\"Black Bear Diner Modesto, Black Bear Diner Modesto, Black Bear Diner Modesto\").element",".maps.containing(.other, identifier:\"Red Lobster, Red Lobster, Red Lobster\").element",".maps.containing(.other, identifier:\"Texas Roadhouse, Texas Roadhouse, Texas Roadhouse\").element",".maps.containing(.other, identifier:\"Wienerschnitzel, Wienerschnitzel, Wienerschnitzel\").element",".maps.containing(.other, identifier:\"You, You, You\").element",".maps.containing(.other, identifier:\"Wingstop, Wingstop, Wingstop\").element",".maps.containing(.other, identifier:\"Fumi Sushi Restaurant, Fumi Sushi Restaurant, Fumi Sushi Restaurant\").element",".maps.containing(.other, identifier:\"Hot Dog on a Stick, Hot Dog on a Stick, Hot Dog on a Stick\").element",".maps.containing(.other, identifier:\"McDonald's, McDonald's, McDonald's\").element",".maps.containing(.other, identifier:\"Jack in the Box, Jack in the Box, Jack in the Box\").element",".maps.containing(.other, identifier:\"Marcella's Restaurant, Marcella's Restaurant, Marcella's Restaurant\").element",".maps.containing(.other, identifier:\"My Garden Cafe, My Garden Cafe, My Garden Cafe\").element",".maps.containing(.other, identifier:\"Modesto Sukiyaki, Modesto Sukiyaki, Modesto Sukiyaki\").element",".maps.containing(.other, identifier:\"Mikes Grillhouse, Mikes Grillhouse, Mikes Grillhouse\").element",".maps.containing(.other, identifier:\"Subway, Subway, Subway\").element",".maps.containing(.other, identifier:\"Little Caesars Pizza, Little Caesars Pizza, Little Caesars Pizza\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,22],[-1,21],[-1,20],[-1,19],[-1,18],[-1,17],[-1,16],[-1,15],[-1,14],[-1,13],[-1,12],[-1,11],[-1,10],[-1,9],[-1,8],[-1,7],[-1,6],[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.otherElements["Fumi Sushi Restaurant, Fumi Sushi Restaurant"].tap()
//        app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"VKPointFeature").element/*[[".maps.containing(.other, identifier:\"Outback Steakhouse, Outback Steakhouse, Outback Steakhouse\").element",".maps.containing(.other, identifier:\"Starbucks, Starbucks, Starbucks\").element",".maps.containing(.other, identifier:\"Olive Garden Italian Restaurant, Olive Garden Italian Restaurant, Olive Garden Italian Restaurant\").element",".maps.containing(.other, identifier:\"Black Bear Diner Modesto, Black Bear Diner Modesto, Black Bear Diner Modesto\").element",".maps.containing(.other, identifier:\"Subway, Subway, Subway\").element",".maps.containing(.other, identifier:\"Red Lobster, Red Lobster, Red Lobster\").element",".maps.containing(.other, identifier:\"Texas Roadhouse, Texas Roadhouse, Texas Roadhouse\").element",".maps.containing(.other, identifier:\"Wienerschnitzel, Wienerschnitzel, Wienerschnitzel\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,8],[-1,7],[-1,6],[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
//        app.otherElements["Starbucks, Starbucks"].tap()
//        app.buttons["Let's Feast!"].tap()
//        
//        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
//        backButton.tap()
//        
//        app2/*@START_MENU_TOKEN@*/.images["person.fill"]/*[[".buttons[\"Let's Feast!\"].images[\"person.fill\"]",".images[\"person.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
//        
//        let collectionViewsQuery = app2.collectionViews
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Brent B"]/*[[".cells.staticTexts[\"Brent B\"]",".staticTexts[\"Brent B\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["brent@email.com"]/*[[".cells.staticTexts[\"brent@email.com\"]",".staticTexts[\"brent@email.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        backButton.tap()
//        app.buttons["Go Down"].tap()
                
                        
    }
    
    func testCanChangeFilters() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        // Check for filters
        let filterShow = app.buttons["Show Filters"]
        XCTAssertTrue(filterShow.exists)
        filterShow.tap()
        let minDollar3 = app.buttons["Min-price-button-3"]
        XCTAssertTrue(minDollar3.exists)
        minDollar3.tap()
        
        let distanceSlider = app.sliders["Distance slider"]
        XCTAssertTrue(distanceSlider.exists)
        let prevValue = Double(distanceSlider.value as! String) ?? 0.0
        distanceSlider.swipeRight()
        let newValue = Double(distanceSlider.value as! String) ?? 0.0
        
        XCTAssertTrue(newValue > prevValue, "The slider value should increase after swiping right.")
        
        distanceSlider.swipeLeft()
        let newestValue = Double(distanceSlider.value as! String) ?? 0.0
        XCTAssertTrue(newestValue < newValue, "The slider value should decrease after swiping left.")
    }
    
    func testCanUseSearch() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()

        let searchButton = app.buttons["Search for restaurants"]
        XCTAssertTrue(searchButton.exists)
        let searchQuery = app.textFields["Search query"]
        XCTAssertTrue(searchQuery.exists)
        searchQuery.tap()
        searchQuery.typeText("Chicken")
        XCTAssertTrue(searchButton.isEnabled)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
