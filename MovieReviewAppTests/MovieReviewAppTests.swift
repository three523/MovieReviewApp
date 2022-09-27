//
//  MovieReviewAppTests.swift
//  MovieReviewAppTests
//
//  Created by 김도현 on 2022/09/26.
//

import XCTest
@testable import MovieReviewApp

final class MovieReviewAppTests: XCTestCase {

    func testRegularExpression() {
        let validateCheck: ValidateCheck = ValidateCheck()
        let testEmail: String = "name@mail.com"
        let testPassword: String = "password21"
        XCTAssertTrue(validateCheck.emailCheck(email: testEmail))
        XCTAssertTrue(validateCheck.passwordCheck(password: testPassword))
    }

}
