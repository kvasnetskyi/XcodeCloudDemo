//
//  HomeViewModelTests.swift
//  XcodeCloudDemoTests
//
//  Created by Artem Kvasnetskyi on 26.06.2022.
//

import XCTest

@testable import XcodeCloudDemo

class HomeViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: HomeViewModel!
    var charactersServiceStub: CharactersServiceStub!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        charactersServiceStub = .init(return: .value)
        sut = .init(charactersService: charactersServiceStub)
    }
    
    override func tearDown() {
        sut = nil
        charactersServiceStub = nil
        
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testHomeViewModel_onViewDidAppear_getCharactersCalled() throws {
        sut.onViewDidAppear()
        
        XCTAssertEqual(charactersServiceStub.numberOfCalls, 1)
    }
    
    func testHomeViewModel_whenGetCharactersCalled_isLoadingPublisherSendTrue() throws {
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.onViewDidAppear()
        )
        
        XCTAssertTrue(isLoading)
    }
    
    func testHomeViewModel_whenGetCharactersFinished_isLoadingPublisherSendFalse() throws {
        let publisher = sut.isLoadingPublisher.collect(2)
        let isLoadingArray = try awaitPublisher(publisher, withAct: sut.onViewDidAppear())
        
        let isLoading = try XCTUnwrap(isLoadingArray.last)
        XCTAssertFalse(isLoading)
    }
    
    func testHomeViewModel_whenGetCharactersFinishedWithError_errorPublisherSendError() throws {
        charactersServiceStub.result = .error
        
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.onViewDidAppear()
        )
    }

    func testHomeViewModel_whenGetCharactersFinished_charactersArrayIsNotEmpty() throws {
        let publisher = sut.isLoadingPublisher.collect(2)
        let _ = try awaitPublisher(publisher, withAct: sut.onViewDidAppear())
        
        XCTAssertFalse(sut.characters.isEmpty)
    }
}
