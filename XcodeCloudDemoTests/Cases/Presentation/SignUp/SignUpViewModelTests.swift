//
//  SignUpViewModelTests.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 24.06.2022.
//

import XCTest

@testable import XcodeCloudDemo

class SignUpViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: SignUpViewModel!
    var builder: SignUpViewModelBuilder!
    var userServiceFake: UserServiceFake!

    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        builder = SignUpViewModelBuilder()
    }

    override func tearDown() {
        builder = nil
        sut = nil
        userServiceFake?.clear()
        userServiceFake = nil
        
        super.tearDown()
    }
}

// MARK: - Test Methods
extension SignUpViewModelTests {
    func testSignUpViewModel_whenEmailAndPasswordsAreValid_inputValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(true)
    }

    func testSignUpViewModel_whenEmailNotValid_inputNotValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailNotValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(false)
    }

    func testSignUpViewModel_whenPasswordsNotValid_inputNotValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordNotValid()
            .makeConfirmPasswordNotValid()
            .build()
        
        // Assert
        try inputNeedToBeValid(false)
    }

    func testSignUpViewModel_whenPasswordsNotEqual_inputNotValid() throws {
        // Arrange & Act
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordNotEqualToPassword()
            .build()
        
        // Assert
        try inputNeedToBeValid(false)
    }

    func testSignUpViewModel_whenSignUpUser_isLoadingPublisherSendTrue() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        // Act
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.signUpUser
        )
        
        // Assert
        XCTAssertTrue(isLoading)
    }

    func testSignUpViewModel_whenSignUpUserFinished_isLoadingPublisherSendFalse() throws {
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        let publisher = sut
            .isLoadingPublisher
            .collect(2)
        
        // Act
        let isLoadingValues = try awaitPublisher(
            publisher, withAct: sut.signUpUser
        )
        
        // Assert
        let isLoading = try XCTUnwrap(isLoadingValues.last)
        XCTAssertFalse(isLoading)
    }

    func testSignUpViewModel_whenSignUpUserFinishedWithError_errorPublisherSendError() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .makeAuthServiceOutputFailure()
            .build()
        
        // Act & Assert
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.signUpUser
        )
    }
    
    func testSignUpViewModel_whenSignUpUserFinished_transitionChanged() throws {
        // Arrange
        sut = builder
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        // Act
        let transition = try awaitPublisher(
            sut.transitionPublisher, withAct: sut.signUpUser
        )
        
        // Assert
        XCTAssertEqual(transition, .success)
    }
    
    func testSignUpViewModel_whenSignUpUserFinished_userDataSaved() throws {
        // Arrange
        userServiceFake = TestDoublesFactory.getUserServiceFake()
        
        sut = builder
            .with(userService: userServiceFake)
            .with(viewState: .onViewDidLoad)
            .makeEmailValid()
            .makePasswordValid()
            .makeConfirmPasswordValid()
            .build()
        
        // Act
        let _ = try awaitPublisher(
            sut.transitionPublisher, withAct: sut.signUpUser
        )
        
        // Assert
        XCTAssertNotNil(userServiceFake.token)
        XCTAssertNotNil(userServiceFake.refreshToken)
    }
}

// MARK: - Private Methods
private extension SignUpViewModelTests {
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
