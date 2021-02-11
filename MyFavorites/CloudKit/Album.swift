//
//  Album.swift
//  MyFavorites
//
//  Created by Fernando de Lucas da Silva Gomes on 26/10/20.
//

import Foundation
import CloudKit

class Album{
    
    let id: CKRecord.ID
    let title : String
    let artist : String
    let cover : CKAsset
    let ano : Int
    
    init?(record: CKRecord){
        guard let title = record["title"] as? String, let artist = record["artist"] as? String, let ano = record["ano"] as? Int,        let cover = record["cover"] as? CKAsset else {return nil}
        
        id = record.recordID
        self.title = title
        self.artist = artist
        self.cover = cover
        self.ano = ano
    }
    
    init(id: CKRecord.ID,title: String, artist: String, cover: CKAsset, ano: Int){
        self.id = id
        self.title = title
        self.artist = artist
        self.cover = cover
        self.ano = ano
    }

}
