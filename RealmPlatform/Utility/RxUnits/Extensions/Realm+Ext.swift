//
//  Realm+Ext.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension RealmSwift.SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}

extension Reactive where Base == Realm {
    
    private func performWriteOperation(_ operation: @escaping () throws -> Void) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    try operation()
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func saveEntity<R: RealmRepresentable>(entity: R, update: Bool = true) -> Observable<Void> where R.RealmType: Object  {
        return performWriteOperation {
            self.base.add(entity.asRealm(), update: update ? .all : .error)
        }
    }
    
    func deleteEntity<R: RealmRepresentable>(entity: R) -> Observable<Void> where R.RealmType: Object {
        return performWriteOperation {
            guard let object = self.base.object(ofType: R.RealmType.self, forPrimaryKey: entity.uid) else { fatalError() }
            self.base.delete(object)
        }
    }
    
    func deleteAllObjects<R: RealmRepresentable>(type: R.Type) -> Observable<Void> where R.RealmType: Object {
        return performWriteOperation {
            let objects = self.base.objects(R.RealmType.self)
            self.base.delete(objects)
        }
    }
    
    func deleteAllEntities() -> Observable<Void>  {
        return performWriteOperation {
            self.base.deleteAll()
        }
    }
}
