import XCTest

final class RegistrationUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRegistrationEnabled() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(signup.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        
        let fullname = app.textFields["Fullname"]
        XCTAssertTrue(fullname.exists)
        fullname.tap()
        fullname.typeText("Michael Jordan")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        let confirmPass = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPass.exists)
        confirmPass.tap()
        confirmPass.typeText("password")

        XCTAssertTrue(signup.isEnabled)
    }
    
    func testInvalidEmail() {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(signup.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name.email.com")
        
        let fullname = app.textFields["Fullname"]
        XCTAssertTrue(fullname.exists)
        fullname.tap()
        fullname.typeText("Michael Jordan")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        let confirmPass = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPass.exists)
        confirmPass.tap()
        confirmPass.typeText("password")

        XCTAssertFalse(signup.isEnabled)
    }
    
    func testInvalidFullname() {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(signup.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        let confirmPass = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPass.exists)
        confirmPass.tap()
        confirmPass.typeText("password")

        XCTAssertFalse(signup.isEnabled)
    }
    
    func testInvalidPassword() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(signup.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        
        let fullname = app.textFields["Fullname"]
        XCTAssertTrue(fullname.exists)
        fullname.tap()
        fullname.typeText("Michael Jordan")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("passw")
        
        let confirmPass = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPass.exists)
        confirmPass.tap()
        confirmPass.typeText("passw")

        XCTAssertFalse(signup.isEnabled)
    }
    
    func testInvalidPasswordConfirmation() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        let switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(signup.isEnabled)
        
        let email = app.textFields["Email Address"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("name@email.com")
        
        let fullname = app.textFields["Fullname"]
        XCTAssertTrue(fullname.exists)
        fullname.tap()
        fullname.typeText("Michael Jordan")
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText("password")
        
        let confirmPass = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPass.exists)
        confirmPass.tap()
        confirmPass.typeText("passwood")

        XCTAssertFalse(signup.isEnabled)
    }

    func testCanReturnToLoginPage() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITestNewUser"] = "true"
        app.launch()
        
        var switchButton = app.staticTexts["Sign up"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signup = app.buttons["Sign up button"]
        XCTAssertTrue(signup.exists)
        XCTAssertFalse(switchButton.exists)
        
        switchButton = app.staticTexts["Sign in"]
        XCTAssertTrue(switchButton.exists)
        switchButton.tap()
        
        let signin = app.buttons["Sign in button"]
        XCTAssertTrue(signin.exists)
    }
}
