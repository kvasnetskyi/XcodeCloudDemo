//
//  SignInViewModelTests.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 15.06.2022.
//

import XCTest

@testable import XcodeCloudDemo

class SignInViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: SignInViewModel!
    var builder: SignInViewModelBuilder!
    var userServiceFake: UserServiceFake!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        builder = SignInViewModelBuilder()
    }
    
    override func tearDown() {
        sut = nil
        builder = nil
        userServiceFake?.clear()
        userServiceFake = nil
        
        super.tearDown()
    }
}

// MARK: - Test Methods
extension SignInViewModelTests {
    func testSignInViewModel_whenEmailAndPasswordAreValid_inputValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(true)
    }
    
    func testSignInViewModel_whenEmailNotValid_inputNotValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailNotValid()
            .makePasswordValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(false)
    }
    
    func testSignInViewModel_whenPasswordNotValid_inputNotValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordNotValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(false)
    }
    
    func testSignInViewModel_whenSignInUser_isLoadingPublisherSendTrue() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .build()
        
        // Act
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.signInUser
        )
        
        // Assert
        XCTAssertTrue(isLoading)
    }
    
    func testSignInViewModel_whenSignInUserFinished_isLoadingPublisherSendFalse() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .build()
        
        let publisher = sut
            .isLoadingPublisher
            .collect(2)
        
        // Act
        let isLoadingValues = try awaitPublisher(
            publisher, withAct: sut.signInUser
        )
        
        // Assert
        let isLoading = try XCTUnwrap(isLoadingValues.last)
        XCTAssertFalse(isLoading)
    }
    
    func testSignInViewModel_whenSignInUserFinishedWithError_errorPublisherSendError() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeAuthServiceOutputFailure()
            .build()
        
        // Act & Assert
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.signInUser
        )
    }

    func testSignInViewModel_whenSignInUserFinished_transitionChanged() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .build()
        
        // Act
        let transition = try awaitPublisher(
            sut.transitionPublisher, withAct: sut.signInUser
        )
        
        // Assert
        XCTAssertEqual(transition, .success)
    }
    
    func testSignInViewModel_whenSignInUserFinished_userDataSaved() throws {
        // Arrange
        userServiceFake = TestDoublesFactory.getUserServiceFake()
        
        sut = builder
            .with(userService: userServiceFake)
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .build()
        
        // Act
        let _ = try awaitPublisher(
            sut.transitionPublisher, withAct: sut.signInUser
        )
        
        // Assert
        XCTAssertNotNil(userServiceFake.token)
        XCTAssertNotNil(userServiceFake.refreshToken)
    }
}

// MARK: - Private Methods
private extension SignInViewModelTests {
    func inputNeedToBeValid(
        _ valid: Bool,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) throws {
        let isValidInput = try awaitPublisher(
            sut.$isInputValid,
            file: file,
            line: line
        )
        
        guard valid else {
            XCTAssertFalse(
                isValidInput,
                "Input is valid",
                file: file,
                line: line
            )
            
            return
        }
        
        XCTAssertTrue(
            isValidInput,
            "Input is not valid",
            file: file,
            line: line
        )
    }
}
