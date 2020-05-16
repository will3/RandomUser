//
//  UserServiceTests.swift
//  RandomUserTests
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Cuckoo
import RxSwift
import SQLite

@testable import RandomUser

class UserServiceSpec: QuickSpec {
    override func spec() {
        var userService: UserServiceImpl!
        var userRepository: MockUserRepository!
        var networkStatus: MockNetworkStatus!
        var connectionFactory: MockConnectionFactory!
        var api: MockRandomUserApi!
        let disposeBag = DisposeBag()
        
        beforeEach {
            userRepository = MockUserRepository()
            networkStatus = MockNetworkStatus()
            connectionFactory = MockConnectionFactory()
            api = MockRandomUserApi()
            
            userService = UserServiceImpl(repository: userRepository, networkStatus: networkStatus, connectionFactory: connectionFactory, api: api)
        }
        
        it("works offline") {
            let expectation = XCTestExpectation(description: "success")

            stub(networkStatus) { stub in
                when(stub.isDisconnected).get.then { _ -> Bool in
                    true
                }
            }

            stub(userRepository) { stub in
                when(stub.getUsers(db: any(), limit: any(), offset: any(), gender: any())).thenReturn([self.buildUser()])
                
                when(stub.countUsers(db: any())).thenReturn(1)
            }
            
            stub(connectionFactory) { stub in
                when(stub.create()).thenReturn(try! Connection())
            }

            userService.getUsers(
                take: 10,
                page: 1,
                gender: .both,
                countryCode: .AU,
                kitten: false)
                .subscribe(onNext: { (r: GetUsersResponse) in
                    switch r {
                    case let .success(users, _):
                        expect(users).to(haveCount(1))
                        expectation.fulfill()
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
            
            self.wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func buildUser() -> User {
        return User(username: "foo", title: "foo", gender: "foo", firstName: "foo", lastName: "foo", dob: Date(), thumbImageUrl: "foo", address: "foo", largeImageUrl: "foo", email: "foo", registered: Date(), phone: "foo", cell: "foo", nat: "foo")
    }
}
