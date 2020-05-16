// MARK: - Mocks generated from file: RandomUser/Api/RandomUserApi.swift at 2020-05-16 00:43:08 +0000

//
//  RandomUserApi.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Cuckoo
@testable import RandomUser

import Foundation
import RxSwift


 class MockRandomUserApi: RandomUserApi, Cuckoo.ProtocolMock {
    
     typealias MocksType = RandomUserApi
    
     typealias Stubbing = __StubbingProxy_RandomUserApi
     typealias Verification = __VerificationProxy_RandomUserApi

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RandomUserApi?

     func enableDefaultImplementation(_ stub: RandomUserApi) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse> {
        
    return cuckoo_manager.call("getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse>",
            parameters: (take, page, gender, countryCode),
            escapingParameters: (take, page, gender, countryCode),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getUsers(take: take, page: page, gender: gender, countryCode: countryCode))
        
    }
    

	 struct __StubbingProxy_RandomUserApi: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(take: M1, page: M2, gender: M3, countryCode: M4) -> Cuckoo.ProtocolStubFunction<(Int, Int, String?, String?), Observable<RandomUserApiResponse>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Int, Int, String?, String?)>] = [wrap(matchable: take) { $0.0 }, wrap(matchable: page) { $0.1 }, wrap(matchable: gender) { $0.2 }, wrap(matchable: countryCode) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockRandomUserApi.self, method: "getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_RandomUserApi: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.OptionalMatchable>(take: M1, page: M2, gender: M3, countryCode: M4) -> Cuckoo.__DoNotUse<(Int, Int, String?, String?), Observable<RandomUserApiResponse>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.OptionalMatchedType == String, M4.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Int, Int, String?, String?)>] = [wrap(matchable: take) { $0.0 }, wrap(matchable: page) { $0.1 }, wrap(matchable: gender) { $0.2 }, wrap(matchable: countryCode) { $0.3 }]
	        return cuckoo_manager.verify("getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class RandomUserApiStub: RandomUserApi {
    

    

    
     func getUsers(take: Int, page: Int, gender: String?, countryCode: String?) -> Observable<RandomUserApiResponse>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<RandomUserApiResponse>).self)
    }
    
}


// MARK: - Mocks generated from file: RandomUser/Repositories/ConnectionFactory.swift at 2020-05-16 00:43:08 +0000

//
//  IDbConnectionFactory.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Cuckoo
@testable import RandomUser

import Foundation
import SQLite


 class MockConnectionFactory: ConnectionFactory, Cuckoo.ProtocolMock {
    
     typealias MocksType = ConnectionFactory
    
     typealias Stubbing = __StubbingProxy_ConnectionFactory
     typealias Verification = __VerificationProxy_ConnectionFactory

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: ConnectionFactory?

     func enableDefaultImplementation(_ stub: ConnectionFactory) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func create() throws -> Connection {
        
    return try cuckoo_manager.callThrows("create() throws -> Connection",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.create())
        
    }
    

	 struct __StubbingProxy_ConnectionFactory: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func create() -> Cuckoo.ProtocolStubThrowingFunction<(), Connection> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockConnectionFactory.self, method: "create() throws -> Connection", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_ConnectionFactory: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func create() -> Cuckoo.__DoNotUse<(), Connection> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("create() throws -> Connection", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class ConnectionFactoryStub: ConnectionFactory {
    

    

    
     func create() throws -> Connection  {
        return DefaultValueRegistry.defaultValue(for: (Connection).self)
    }
    
}


// MARK: - Mocks generated from file: RandomUser/Repositories/UserRepository.swift at 2020-05-16 00:43:08 +0000

//
//  UserRepository.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Cuckoo
@testable import RandomUser

import Foundation
import SQLite


 class MockUserRepository: UserRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = UserRepository
    
     typealias Stubbing = __StubbingProxy_UserRepository
     typealias Verification = __VerificationProxy_UserRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: UserRepository?

     func enableDefaultImplementation(_ stub: UserRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func saveUsers(db: Connection, items: [User]) throws {
        
    return try cuckoo_manager.callThrows("saveUsers(db: Connection, items: [User]) throws",
            parameters: (db, items),
            escapingParameters: (db, items),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.saveUsers(db: db, items: items))
        
    }
    
    
    
     func countUsers(db: Connection) throws -> Int {
        
    return try cuckoo_manager.callThrows("countUsers(db: Connection) throws -> Int",
            parameters: (db),
            escapingParameters: (db),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.countUsers(db: db))
        
    }
    
    
    
     func getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User] {
        
    return try cuckoo_manager.callThrows("getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User]",
            parameters: (db, limit, offset, gender),
            escapingParameters: (db, limit, offset, gender),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getUsers(db: db, limit: limit, offset: offset, gender: gender))
        
    }
    

	 struct __StubbingProxy_UserRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func saveUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(db: M1, items: M2) -> Cuckoo.ProtocolStubNoReturnThrowingFunction<(Connection, [User])> where M1.MatchedType == Connection, M2.MatchedType == [User] {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection, [User])>] = [wrap(matchable: db) { $0.0 }, wrap(matchable: items) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockUserRepository.self, method: "saveUsers(db: Connection, items: [User]) throws", parameterMatchers: matchers))
	    }
	    
	    func countUsers<M1: Cuckoo.Matchable>(db: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Connection), Int> where M1.MatchedType == Connection {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection)>] = [wrap(matchable: db) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockUserRepository.self, method: "countUsers(db: Connection) throws -> Int", parameterMatchers: matchers))
	    }
	    
	    func getUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(db: M1, limit: M2, offset: M3, gender: M4) -> Cuckoo.ProtocolStubThrowingFunction<(Connection, Int, Int, String?), [User]> where M1.MatchedType == Connection, M2.MatchedType == Int, M3.MatchedType == Int, M4.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection, Int, Int, String?)>] = [wrap(matchable: db) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: offset) { $0.2 }, wrap(matchable: gender) { $0.3 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockUserRepository.self, method: "getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User]", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_UserRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func saveUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(db: M1, items: M2) -> Cuckoo.__DoNotUse<(Connection, [User]), Void> where M1.MatchedType == Connection, M2.MatchedType == [User] {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection, [User])>] = [wrap(matchable: db) { $0.0 }, wrap(matchable: items) { $0.1 }]
	        return cuckoo_manager.verify("saveUsers(db: Connection, items: [User]) throws", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func countUsers<M1: Cuckoo.Matchable>(db: M1) -> Cuckoo.__DoNotUse<(Connection), Int> where M1.MatchedType == Connection {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection)>] = [wrap(matchable: db) { $0 }]
	        return cuckoo_manager.verify("countUsers(db: Connection) throws -> Int", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getUsers<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable>(db: M1, limit: M2, offset: M3, gender: M4) -> Cuckoo.__DoNotUse<(Connection, Int, Int, String?), [User]> where M1.MatchedType == Connection, M2.MatchedType == Int, M3.MatchedType == Int, M4.OptionalMatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(Connection, Int, Int, String?)>] = [wrap(matchable: db) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: offset) { $0.2 }, wrap(matchable: gender) { $0.3 }]
	        return cuckoo_manager.verify("getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class UserRepositoryStub: UserRepository {
    

    

    
     func saveUsers(db: Connection, items: [User]) throws  {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func countUsers(db: Connection) throws -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
     func getUsers(db: Connection, limit: Int, offset: Int, gender: String?) throws -> [User]  {
        return DefaultValueRegistry.defaultValue(for: ([User]).self)
    }
    
}


// MARK: - Mocks generated from file: RandomUser/Utils/NetworkStatus.swift at 2020-05-16 00:43:08 +0000

//
//  Reachability.swift
//  RandomUser
//
//  Created by will on 16/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Cuckoo
@testable import RandomUser

import Foundation


 class MockNetworkStatus: NetworkStatus, Cuckoo.ProtocolMock {
    
     typealias MocksType = NetworkStatus
    
     typealias Stubbing = __StubbingProxy_NetworkStatus
     typealias Verification = __VerificationProxy_NetworkStatus

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: NetworkStatus?

     func enableDefaultImplementation(_ stub: NetworkStatus) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var isDisconnected: Bool {
        get {
            return cuckoo_manager.getter("isDisconnected",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.isDisconnected)
        }
        
    }
    

    

    

	 struct __StubbingProxy_NetworkStatus: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var isDisconnected: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockNetworkStatus, Bool> {
	        return .init(manager: cuckoo_manager, name: "isDisconnected")
	    }
	    
	    
	}

	 struct __VerificationProxy_NetworkStatus: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var isDisconnected: Cuckoo.VerifyReadOnlyProperty<Bool> {
	        return .init(manager: cuckoo_manager, name: "isDisconnected", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	}
}

 class NetworkStatusStub: NetworkStatus {
    
    
     var isDisconnected: Bool {
        get {
            return DefaultValueRegistry.defaultValue(for: (Bool).self)
        }
        
    }
    

    

    
}

