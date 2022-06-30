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
    var authServiceStub: AuthServiceStub!
    var userServiceFake: UserServiceFake!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        authServiceStub = AuthServiceStub(return: .value)
        userServiceFake = UserServiceFake()
        sut = SignInViewModel(
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
    func testSignInViewModel_whenEmailAndPasswordAreValid_inputValid() throws {
        let publisher = sut.$isInputValid.collect(3)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email@email.com"
            sut.password = "12345aA!"
        })
        
        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertTrue(isValidInput)
    }
    
    func testSignInViewModel_whenEmailNotValid_inputNotValid() throws {
        let publisher = sut.$isInputValid.collect(3)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email.com"
            sut.password = "12345aA!"
        })

        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertFalse(isValidInput)
    }
    
    func testSignInViewModel_whenPasswordNotValid_inputNotValid() throws {
        let publisher = sut.$isInputValid.collect(3)
        let isValidInputValues = try awaitPublisher(publisher, withAct: {
            sut.email = "email@email.com"
            sut.password = "12345aA"
        })
        
        let isValidInput = try XCTUnwrap(isValidInputValues.last)
        XCTAssertFalse(isValidInput)
    }
    
    func testSignInViewModel_whenSignInUser_isLoadingPublisherSendTrue() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.signInUser
        )
        
        XCTAssertTrue(isLoading)
    }
    
    func testSignInViewModel_whenSignInUserFinished_isLoadingPublisherSendFalse() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        
        let isLoadingValues = try awaitPublisher(
            sut.isLoadingPublisher.collect(2), withAct: sut.signInUser
        )
        
        let isLoading = try XCTUnwrap(isLoadingValues.last)
        XCTAssertFalse(isLoading)
    }
    
    func testSignInViewModel_whenSignInUserFinishedWithError_errorPublisherSendError() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        authServiceStub.result = .error
        
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.signInUser
        )
    }

    func testSignInViewModel_whenSignInUserFinished_userDataSavedAndTransitionChanged() throws {
        sut.email = "email@email.com"
        sut.password = "12345aA!"
        
        let transition = try awaitPublisher(sut.transitionPublisher, withAct: sut.signInUser)
        XCTAssertEqual(transition, .success)
        XCTAssertNotNil(userServiceFake.token)
        XCTAssertNotNil(userServiceFake.refreshToken)
    }
}
