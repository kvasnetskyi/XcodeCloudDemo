//
//  AuthSelectViewModelTests.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 14.06.2022.
//

import XCTest

@testable import XcodeCloudDemo

class AuthSelectViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: AuthSelectViewModel!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        sut = AuthSelectViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

// MARK: - Test Methods
extension AuthSelectViewModelTests {
    func testAuthSelectViewModel_whenSignInCalled_transitionChange() throws {
        // Arrange
        let transition = try awaitPublisher(
            sut.transitionPublisher,
            // Act
            withAct: sut.showSignIn()
        )
        
        // Assert
        XCTAssertEqual(transition, .signIn)
    }
    
    func testAuthSelectViewModel_whenSignUpCalled_transitionChange() throws {
        // Arrange
        let transition = try awaitPublisher(
            sut.transitionPublisher,
            // Act
            withAct: sut.showSignUp()
        )
        
        // Assert
        XCTAssertEqual(transition, .signUp)
    }
}
