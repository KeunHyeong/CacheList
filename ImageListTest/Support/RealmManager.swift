//
//  RealmManager.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    private init() {}
    
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error Realm: \(error)")
        }
    }
    
    func saveItem(_ item: SearchItem) {
        do {
            try realm.write {
                let imageMax = realm.objects(RealmImageDocument.self).max(ofProperty: "orderIndex") as Int? ?? 0
                let videoMax = realm.objects(RealmVideoDocument.self).max(ofProperty: "orderIndex") as Int? ?? 0
                let combinedMax = max(imageMax, videoMax)
                let newOrderIndex = combinedMax + 1
                
                switch item {
                case .image(let document):
                    let localImage = RealmImageDocument(from: document)
                    localImage.orderIndex = newOrderIndex
                    realm.add(localImage, update: .modified)
                    
                case .video(let document):
                    let localVideo = RealmVideoDocument(from: document)
                    localVideo.orderIndex = newOrderIndex
                    realm.add(localVideo, update: .modified)
                }
            }
        } catch {
            print("Error saveItem: \(error)")
        }
    }
    
    func deleteItem(_ item: SearchItem) {
        do {
            try realm.write {
                switch item {
                case .image(let document):
                    if let localImage = realm.objects(RealmImageDocument.self).filter("thumbnailURL == %@", document.thumbnailURL).first {
                        realm.delete(localImage)
                    }
                case .video(let document):
                    if let localVideo = realm.objects(RealmVideoDocument.self).filter("thumbnail == %@", document.thumbnail).first {
                        realm.delete(localVideo)
                    }
                }
            }
        } catch {
            print("Error deleteItem: \(error)")
        }
    }
    
    func fetchAllItems() -> [SearchItem] {
        let imageResults = realm.objects(RealmImageDocument.self).map { SearchItem.image(ImageDocument(localUser: $0)) }
        let videoResults = realm.objects(RealmVideoDocument.self).map { SearchItem.video(VideoDocument(localUser: $0)) }
        
        let allResults: [SearchItem] = Array(imageResults) + Array(videoResults)
        
        return allResults.sorted { $0.orderIndex < $1.orderIndex }
    }
}
