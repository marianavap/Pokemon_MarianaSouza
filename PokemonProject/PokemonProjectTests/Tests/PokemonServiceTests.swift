//
//  PokemonServiceTests.swift
//  PokemonTests
//
//  Created by Mariana V. A. Souza on 15/04/20.
//  Copyright © 2019 Mariana. All rights reserved.
//

import XCTest

@testable import PokemonProject

class URLSessionMock: BaseMock, BaseURLSession {
    
    var urlAssertBlock: ((URL?) -> Void)?
    var urlsession = URLSession.shared
    
    func getDetailValues(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlAssertBlock?(url)
        do {
            let data = try loadResponse()
            completionHandler(data, nil, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
    }
    
    func postFavorite(from url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        do {
            let data = try loadResponse()
            completionHandler(data, nil, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
    }
        
    func loadData(from url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        urlAssertBlock?(url)
        do {
            let data = try loadResponse()
            completionHandler(data, nil, nil)
        } catch {
            completionHandler(nil, nil, error)
        }
    }
}

class PokemonServiceTests: BaseTests {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testNotReachable() {
        //Arrange
        let urlSessionMock = URLSessionMock.init()
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BaseProvider(session: urlSessionMock.urlsession, reachability: ReachabilityMock(reachable: false))
        
        //Act
        service.getValues(startIndex: 0) { callback in
            do {
                _ = try callback()
            } catch BaseError.offlineMode {
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
    }
    
    func testApiError() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "PokemonParseError", error: BaseError.generic)
        let expectation = self.expectation(description: "Expect generic error")
        
        let service = BaseProvider(session: urlSessionMock.urlsession, reachability: ReachabilityMock())
        
        //Act
        service.getValues(startIndex: 0) { callback in
            do {
                _ = try callback()
                expectation.fulfill()
            } catch BaseError.generic {

            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)

    }
    
    func testSuccess() {
        //Arrange
        let urlSessionMock = URLSessionMock.init(file: "Pokemon")
        let expectation = self.expectation(description: "Expect success")
        
        let service = BaseProvider(session: urlSessionMock.urlsession, reachability: ReachabilityMock())
        var mainList: MainList!
        //Act
        service.getValues(startIndex: 1) { callback in
            do {
                mainList = try callback()
                
                expectation.fulfill()
            } catch { }
        }
        
        //Assert
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mainList.results.count, 10)
        XCTAssertEqual(mainList.results.first?.name, "metapod")
        XCTAssertEqual(mainList.results.first?.url, "https://pokeapi.co/api/v2/pokemon/11/")
    }
}
