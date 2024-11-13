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
    
    func testCanTapMapItems() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        let restaurant = app.otherElements["Pasta House, Pasta House"]
        XCTAssertTrue(restaurant.exists)
        restaurant.tap()
        let locatorButton = app.buttons["Tracking"]
        XCTAssertTrue(locatorButton.exists)
        locatorButton.tap()
        let randomizer = app.buttons["Randomizer"]
        XCTAssertTrue(randomizer.exists)
        randomizer.tap()
    }
    
    func testMapItemFocusesScrollItem() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        // Tap on item in map
        let restaurant = app.otherElements["Pasta House, Pasta House"]
        XCTAssertTrue(restaurant.exists)
        restaurant.tap()                                                        
        let openIn = app.buttons["Pasta House open in Apple Maps"]
        XCTAssertTrue(openIn.waitForExistence(timeout: 2), "The selected restaurant should be visible and focused in the scroll view.")
        XCTAssertTrue(openIn.isHittable)
    }
    
    func testCanGenerateRoute() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        // Tap on item in map
        let restaurant = app.otherElements["Pasta House, Pasta House"]
        XCTAssertTrue(restaurant.exists)
        restaurant.tap()
        let predicate = NSPredicate(format: "label CONTAINS 'Pasta House ('")
        let updated = app.otherElements.containing(predicate).firstMatch
        XCTAssertTrue(updated.waitForExistence(timeout: 2), "The route to the restaurant should be visibile and the destination time should be updated")
    }
    
    func testCanGoToSettings() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        let settingsPageButton = app.images["Profile Settings"]
        XCTAssertTrue(settingsPageButton.exists)
        settingsPageButton.tap()
        
        let signOut = app.buttons["Sign out"]
        XCTAssertTrue(signOut.waitForExistence(timeout: 3), "Should show settings page")
    }
    
    func testRandomizerButtonEnabled() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launch()
        
        let randomizer = app.buttons["Randomizer"]
        XCTAssertTrue(randomizer.exists)
        XCTAssertTrue(randomizer.isEnabled)
    }
    
    func testRandomizerButtonDisabled() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestMockUser"] = "true"
        app.launchEnvironment["NoRestaurants"] = "true"
        app.launch()
        
        let randomizer = app.buttons["Randomizer"]
        XCTAssertTrue(randomizer.exists)
        XCTAssertFalse(randomizer.isEnabled)
    }
}
