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
    var builder: HomeViewModelBuilder!
    var charactersServiceMock: CharactersServiceMock!
    
    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
        
        builder = HomeViewModelBuilder()
    }
    
    override func tearDown() {
        builder = nil
        sut = nil
        charactersServiceMock = nil
        
        super.tearDown()
    }
}

// MARK: - Test Methods
extension HomeViewModelTests {
    func testHomeViewModel_onViewDidAppear_getCharactersCalled() throws {
        // Arrange & Act
        charactersServiceMock = TestDoublesFactory.getCharactersServiceMock(result: .success)
        
        sut = builder
            .with(viewState: .onViewDidAppear)
            .with(charactersService: charactersServiceMock)
            .build()
        
        // Assert
        XCTAssertEqual(charactersServiceMock.numberOfCalls, 1)
    }
    
    func testHomeViewModel_whenGetCharactersCalled_isLoadingPublisherSendTrue() throws {
        // Arrange
        sut = builder.build()
        
        // Act
        let isLoading = try awaitPublisher(
            sut.isLoadingPublisher, withAct: sut.onViewDidAppear
        )
        
        // Assert
        XCTAssertTrue(isLoading)
    }
    
    func testHomeViewModel_whenGetCharactersFinished_isLoadingPublisherSendFalse() throws {
        // Arrange
        sut = builder.build()
        
        let publisher = sut
            .isLoadingPublisher
            .collect(2)
        
        // Act
        let isLoadingArray = try awaitPublisher(
            publisher, withAct: sut.onViewDidAppear
        )
        
        // Assert
        let isLoading = try XCTUnwrap(isLoadingArray.last)
        XCTAssertFalse(isLoading)
    }
    
    func testHomeViewModel_whenGetCharactersFinishedWithError_errorPublisherSendError() throws {
        // Arrange
        charactersServiceMock = TestDoublesFactory.getCharactersServiceMock(result: .failure)
        sut = builder
            .with(charactersService: charactersServiceMock)
            .build()
        
        // Act & Assert
        let _ = try awaitPublisher(
            sut.errorPublisher, withAct: sut.onViewDidAppear()
        )
    }

    func testHomeViewModel_whenGetCharactersFinished_charactersArrayIsNotEmpty() throws {
        // Arrange
        sut = builder.build()
        
        let publisher = sut
            .isLoadingPublisher
            .collect(2)
        
        // Act
        let _ = try awaitPublisher(publisher, withAct: sut.onViewDidAppear())
        
        // Assert
        XCTAssertFalse(sut.characters.isEmpty)
    }
}
