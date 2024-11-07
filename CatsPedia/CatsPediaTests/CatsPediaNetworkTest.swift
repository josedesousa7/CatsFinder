//
//  CatsPediaTests.swift
//  CatsPediaTests
//
//  Created by José Marques on 07/11/2024.
//

import XCTest
@testable import CatsPedia

final class CatsPediaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiClientNetwork() async throws {
        // given

        // when
        let cats: [Breed] = try await CatPediaApiClient().fetchCatsList()

        // then
        XCTAssertTrue(cats.count > 0)
    }
}
