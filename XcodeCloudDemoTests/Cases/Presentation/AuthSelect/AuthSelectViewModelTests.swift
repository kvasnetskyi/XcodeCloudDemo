//
//  AuthSelectViewModelTests.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 14.06.2022.
//

import XCTest

@testable import XcodeCloudDemo

class AuthSelectViewModelTests: XCTestCase {
    func testAuthSelectViewModel_whenSignInCalled_transitionChange() throws {
        let sut = AuthSelectViewModel()
        let transition = try awaitPublisher(
            sut.transitionPublisher,
            withAct: sut.showSignIn()
        )
        
        XCTAssertEqual(transition, .signIn)
    }
    
    func testAuthSelectViewModel_whenSignUpCalled_transitionChange() throws {
        let sut = AuthSelectViewModel()
        let transition = try awaitPublisher(
            sut.transitionPublisher,
            withAct: sut.showSignUp()
        )
        
        XCTAssertEqual(transition, .signUp)
    }
}
