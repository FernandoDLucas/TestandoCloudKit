//
//  CloudKitModel.swift
//  MyFavorites
//
//  Created by Fernando de Lucas da Silva Gomes on 28/10/20.
//

import Foundation
import CloudKit

class CloudKitModel{
    
    let container : CKContainer
    let publicDB : CKDatabase
    let privateDB : CKDatabase
    
    static let current = CloudKitModel()
    
    init(){
        container = CKContainer.init(identifier: "iCloud.com.FernandoLucas.Teste")
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func fetchAllAlbum(_ completion: @escaping (Result<[Album], Error>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Album", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { result, error in
            
            if let falha = error {
                DispatchQueue.main.async {
                    completion(.failure(falha))
                }
            }
            
            guard let arrayCKRecord = result else { return}
            
            let albuns = arrayCKRecord.compactMap {
                Album.init(record: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(albuns))
            }
        }
    }
    
    func saveAlbum(album: Album, _ completion: @escaping (Result<CKRecord,Error>) -> Void) {
        
        let newRecord = CKRecord(recordType: "Album")
        newRecord.setValue(album.ano, forKey: "ano")
        newRecord.setValue(album.artist, forKey: "artist")
        newRecord.setValue(album.cover, forKey: "cover")
        newRecord.setValue(album.title, forKey: "title")

        publicDB.save(newRecord) { result, error in
            
            if let falha = error {
                DispatchQueue.main.async {
                    completion(.failure(falha))
                }
            }
            
            if let registro = result{
                DispatchQueue.main.async {
                    completion(.success(registro))
                }
            }
        }
    }
    
    
    func fetchByArtist(artist: String, _ completion: @escaping (Result<[Album], Error>) -> Void) {
        
        let predicate = NSPredicate(format: "artist = %@", artist )
        
        let query = CKQuery(recordType: "Album", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { result, error in
            
            if let falha = error {
                DispatchQueue.main.async {
                    completion(.failure(falha))
                }
            }
            
            guard let arrayCKRecord = result else { return}
            
            let albuns = arrayCKRecord.compactMap {
                Album.init(record: $0)
            }
            
            DispatchQueue.main.async {
                completion(.success(albuns))
            }
        }
    }
}
