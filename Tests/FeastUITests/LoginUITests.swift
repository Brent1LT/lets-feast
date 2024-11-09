import XCTest

final class FeastUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    func testLoginEnabled() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let signin = app.buttons["Sign in button"]
        XCTAssertTrue(signin.exists)
        
        XCTAssertFalse(signin.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")

        XCTAssertTrue(signin.isEnabled)
    }
    
    func testValidEmailField() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let signin = app.buttons["Sign in button"]
        XCTAssertTrue(signin.exists)
        
        XCTAssertFalse(signin.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name")
        XCTAssertFalse(signin.isEnabled)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        XCTAssertFalse(signin.isEnabled)
        
        email.tap()
        email.typeText("@email.com")
        XCTAssertTrue(signin.isEnabled)
    }
    
    func testInvalidEmailField() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let signin = app.buttons["Sign in button"]
        XCTAssertTrue(signin.exists)
        
        XCTAssertFalse(signin.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name.email.com")
        XCTAssertFalse(signin.isEnabled)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        XCTAssertFalse(signin.isEnabled)
    }
    
    func testInvalidPasswordField() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let signin = app.buttons["Sign in button"]
        XCTAssertTrue(signin.exists)
        
        XCTAssertFalse(signin.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        XCTAssertFalse(signin.isEnabled)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("passw")
        
        XCTAssertFalse(signin.isEnabled)
    }
    
    func testCanRegister() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()

        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
    }
}
