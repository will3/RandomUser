//
//  AppModule.swift
//  RandomUser
//
//  Created by will on 15/05/20.
//  Copyright © 2020 will. All rights reserved.
//

import Foundation
import Reachability
import Swinject

class AppModule {
    private static var container: Container?

    static var defaultContainer: Container {
        if let container = container {
            return container
        }

        container = buildContainer()
        return container!
    }

    private static func buildContainer() -> Container {
        let container = Container()

        container.register(Reachability.self) { _ in
            try! Reachability()
        }

        container.register(Migrations.self) { r in
            let connectionFactory = r.resolve(ConnectionFactory.self)!
            return Migrations(connectionFactory: connectionFactory)
        }

        container.register(ConnectionFactory.self) { _ in
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            return ConnectionFactory(filename: "\(path)/db.sqlite3")
        }

        container.register(DispatchQueue.self, name: "database") { _ in
            DispatchQueue(label: "will.company.RandomUser.UserRepository.queue")
        }

        container.register(IUserRepository.self) { r in
            let queue = r.resolve(DispatchQueue.self, name: "database")!
            return UserRepository(queue: queue)
        }

        container.register(IRandomUserApi.self) { _ in
            RandomUserApi(baseURL: "https://randomuser.me/api", seed: 1337)
        }

        container.register(IUserService.self) { r in
            let repository = r.resolve(IUserRepository.self)!
            let reachability = r.resolve(Reachability.self)!
            let connectionFactory = r.resolve(ConnectionFactory.self)!
            let api = r.resolve(IRandomUserApi.self)!

            return UserService(
                repository: repository,
                reachability: reachability,
                connectionFactory: connectionFactory,
                api: api
            )
        }

        container.register(PersonListViewController.self) { _ in
            PersonListViewController(nibName: "PersonListViewController", bundle: nil)
        }

        container.register(ProfileGalleryViewController.self) { _ in
            ProfileGalleryViewController(nibName: "ProfileGalleryViewController", bundle: nil)
        }

        container.register(ProfileFilterViewController.self) { _ in
            ProfileFilterViewController(nibName: "ProfileFilterViewController", bundle: nil)
        }

        container.register(AppContainerViewController.self) { r in
            let listViewController = r.resolve(PersonListViewController.self)!
            let profileGalleryViewController = r.resolve(ProfileGalleryViewController.self)!
            let filterViewController = r.resolve(ProfileFilterViewController.self)!

            let containerViewController = AppContainerViewController(
                listViewController: listViewController,
                profileGalleryViewController: profileGalleryViewController,
                filterViewController: filterViewController
            )

            containerViewController.userService = r.resolve(IUserService.self)!

            return containerViewController
        }

        return container
    }
}
