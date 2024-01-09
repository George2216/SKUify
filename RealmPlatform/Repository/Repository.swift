//
//  Repository.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

public protocol AbstractRepository {
    associatedtype T
    func queryAll() -> Observable<[T]>
    func saveEntity(entity: T) -> Observable<Void>
    func saveEntities(entities: [T]) -> Observable<Void>
    func deleteEntity(entity: T) -> Observable<Void>
    func deleteAllObjects(type: T.Type) -> Observable<Void>
}

final class Repository<T: RealmRepresentable>: AbstractRepository where T == T.RealmType.DomainType, T.RealmType: Object {
    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration) {
        self.configuration = configuration
        let name = "com.TryCleanProject.RealmPlatform.Repository"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }

    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self)
            return Observable.array(from: objects)
                .mapToDomain()
        }
        .subscribe(on: scheduler)
    }

    func saveEntity(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.saveEntity(entity: entity)
        }
        .subscribe(on: scheduler)
    }

    func saveEntities(entities: [T]) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.saveEntities(entities: entities)
        }
        .subscribe(on: scheduler)
    }
    
    func deleteEntity(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.deleteEntity(entity: entity)
        }
        .subscribe(on: scheduler)
    }

    func deleteAllObjects(type: T.Type) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.deleteAllObjects(type: type)
        }
        .subscribe(on: scheduler)
    }
    
    func deleteAllEntities() -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.deleteAllEntities()
        }
        .subscribe(on: scheduler)
    }
    
}


