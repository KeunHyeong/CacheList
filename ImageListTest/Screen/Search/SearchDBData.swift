//
//  SearchDBData.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//
import Foundation
import RealmSwift

// MARK: - Meta 정보
class RealmMeta: Object {
    @Persisted var totalCount: Int = 0
    @Persisted var pageableCount: Int = 0
    @Persisted var isEnd: Bool = false

    convenience init(totalCount: Int, pageableCount: Int, isEnd: Bool) {
        self.init()
        self.totalCount = totalCount
        self.pageableCount = pageableCount
        self.isEnd = isEnd
    }
    
    convenience init(from meta: Meta) {
        self.init(totalCount: meta.totalCount, pageableCount: meta.pageableCount, isEnd: meta.isEnd)
    }
}

class RealmImageDocument: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var collection: String = ""
    @Persisted var thumbnailURL: String = ""
    @Persisted var imageURL: String = ""
    @Persisted var width: Int = 0
    @Persisted var height: Int = 0
    @Persisted var displaySitename: String = ""
    @Persisted var docURL: String = ""
    @Persisted var datetime: String = ""
    @Persisted var isLiked: Bool = false
    @Persisted var orderIndex: Int = 0

    convenience init(from document: ImageDocument) {
        self.init()
        self.collection = document.collection
        self.thumbnailURL = document.thumbnailURL
        self.imageURL = document.imageURL
        self.width = document.width
        self.height = document.height
        self.displaySitename = document.displaySitename
        self.docURL = document.docURL
        self.datetime = document.datetime
        self.isLiked = document.isLiked
        self.orderIndex = document.orderIndex
    }
}

class RealmVideoDocument: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var url: String = ""
    @Persisted var thumbnail: String = ""
    @Persisted var playTime: Int = 0
    @Persisted var datetime: String = ""
    @Persisted var author: String = ""
    @Persisted var isLiked: Bool = false
    @Persisted var orderIndex: Int = 0

    convenience init(from document: VideoDocument) {
        self.init()
        self.title = document.title
        self.url = document.url
        self.thumbnail = document.thumbnail
        self.playTime = document.playTime
        self.datetime = document.datetime
        self.author = document.author
        self.isLiked = document.isLiked
        self.orderIndex = document.orderIndex
    }
}

class RealmImageResponse: Object {
    @Persisted var meta: RealmMeta?
    @Persisted var documents: List<RealmImageDocument> = List()
}

class RealmVideoResponse: Object {
    @Persisted var meta: RealmMeta?
    @Persisted var documents: List<RealmVideoDocument> = List()
}
