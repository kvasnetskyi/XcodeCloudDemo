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
    var authServiceStub: AuthServiceStub!
    var userServiceFake: UserServiceFake!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        authServiceStub = AuthServiceStub(return: .value)
        userServiceFake = UserServiceFake()
        sut = SignUpViewModel(
            authService: authServiceStub,
            userService: userServiceFake,
            validator: Validator()
        )
        
        sut.onViewDidLoad()
    }
    
    override func tearDown() {
        sut = nil
        authServiceStub = nil
        userServiceFake.clear()
        userServiceFake = nil
        
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testSignUpViewModel_whenEmailAndPasswordsAreValid_inputValid() throws {
        let publisher = sut.$isInputValid.collect(4)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email@email.com"
            sut.password = "12345aA!"
            sut.confirmPassword = sut.password
        })
        
        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertTrue(isValidInput)
    }
    
    func testSignUpViewModel_whenEmailNotValid_inputNotValid() throws {
        let publisher = sut.$isInputValid.collect(4)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email.com"
            sut.password = "12345aA!"
            sut.confirmPassword = sut.password
        })

        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertFalse(isValidInput)
    }
    
    func testSignUpViewModel_whenPasswordsNotValid_inputNotValid() throws {
        let publisher = sut.$isInputValid.collect(4)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email@email.com"
            sut.password = "12345aA"
            sut.confirmPassword = sut.password
        })
        
        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertFalse(isValidInput)
    }
    
    func testSignUpViewModel_whenPasswordsNotEqual_inputNotValid() throws {
        let publisher = sut.$isInputValid.collect(4)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email@email.com"
            sut.password = "12345aA!"
            sut.confirmPassword = "12345aA!!"
        })
        
        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertFalse(isValidInput)
    }
    
    func testSignUpViewModel_whenSignUpUser_isLoadingPublisherSendTrue() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        sut.confirmPassword = sut.password
        
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.signUpUser
        )
        
        XCTAssertTrue(isLoading)
    }
    
    func testSignUpViewModel_whenSignUpUserFinished_isLoadingPublisherSendFalse() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        sut.confirmPassword = sut.password
        
        let isLoadingValues = try awaitPublisher(
            sut.isLoadingPublisher.collect(2), withAct: sut.signUpUser
        )
        
        let isLoading = try XCTUnwrap(isLoadingValues.last)
        XCTAssertFalse(isLoading)
    }
    
    func testSignUpViewModel_whenSignUpUserFinishedWithError_errorPublisherSendError() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        sut.confirmPassword = sut.password
        authServiceStub.result = .error
        
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.signUpUser
        )
    }

    func testSignUpViewModel_whenSignUpUserFinished_userDataSavedAndTransitionChanged() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        sut.confirmPassword = sut.password
        
        let transition = try awaitPublisher(sut.transitionPublisher, withAct: sut.signUpUser)
        XCTAssertEqual(transition, .success)
        XCTAssertNotNil(userServiceFake.token)
        XCTAssertNotNil(userServiceFake.refreshToken)
    }
}
