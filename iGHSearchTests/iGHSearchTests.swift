//
//  iGHSearchTests.swift
//  iGHSearchTests
//
//  Created by s.zhelev on 23.01.22.
//

import XCTest
import Combine
@testable import iGHSearch

class iGHSearchTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        
        subscriptions = .init()
    }
    
    override func tearDownWithError() throws {
        
        subscriptions = .init()
    }

    func testSearchRepositories() throws {
        
        let githubRepository = GithubRepository(githubApi: CombineGithubApi.mocked)
        let viewModel = GithubSearchViewModel(repository: githubRepository)
        
        doSearch(query: "qwerty123456", viewModel: viewModel)
        
        XCTAssertEqual(viewModel.repositories.count, Config.DEFAULT_PAGE_SIZE)
        XCTAssertEqual(githubRepository.state.page, 1)
        XCTAssertEqual(githubRepository.state.totalResults, 11)
        XCTAssertEqual(githubRepository.state.query, "qwerty123456")
        XCTAssert(viewModel.hasMoreToLoad)
        
        doSearch(query: "qwerty123456", viewModel: viewModel)
        
        XCTAssertEqual(githubRepository.state.page, 2)
        XCTAssert(!viewModel.hasMoreToLoad)
        
        viewModel.reset()
        XCTAssertEqual(githubRepository.state.page, 0)
        XCTAssertEqual(githubRepository.state.totalResults, 0)
        XCTAssertEqual(githubRepository.state.query, nil)
        XCTAssert(!viewModel.hasMoreToLoad)
    }
    
    private func doSearch(query: String, viewModel: GithubSearchViewModel) {
        
        let e = expectation(description: #function)
        viewModel.search(searchTerm: query)
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        e.fulfill()
                    case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2)
    }
}
