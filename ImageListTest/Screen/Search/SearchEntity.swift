//
//  SearchEntity.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation
import RealmSwift

enum SearchItem: Hashable, Equatable {
    case image(ImageDocument)
    case video(VideoDocument)
    
    var id: String {
        switch self {
        case .image(let document):
            return document.thumbnailURL
        case .video(let document):
            return document.thumbnail
        }
    }
    
    var datetime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        switch self {
        case .image(let document):
            return formatter.date(from: document.datetime)
        case .video(let document):
            return formatter.date(from: document.datetime)
        }
    }
    
    var dateString: String {
        guard let date = datetime else { return "date error" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\nHH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
    var thumbnaiURL: URL {
        switch self {
        case .image(let document):
            let url: URL = URL(string: document.thumbnailURL)!
            return url
        case .video(let document):
            let url: URL = URL(string: document.thumbnail)!
            return url
        }
    }
    
    var liked: Bool {
        switch self {
        case .image(let document):
            return document.isLiked
        case .video(let document):
            return document.isLiked
        }
    }
    
    mutating func toggleLike() {
        switch self {
        case .image(var document):
            document.isLiked.toggle()
            self = .image(document)
        case .video(var document):
            document.isLiked.toggle()
            self = .video(document)
        }
    }
    
    var orderIndex: Int {
        switch self{
        case .image(let document):
            return document.orderIndex
        case .video(let document):
            return document.orderIndex
        }
    }
    
    var width: CGFloat {
        switch self {
        case .image(_):
            return 130
        case .video(_):
            return 100
        }
    }
    
    var height: CGFloat {
        switch self {
        case .image(_):
            return 150
        case .video(_):
            return 100
        }
    }
}

struct ImageResponse: Codable, Equatable, Hashable {
    let meta: Meta
    let documents: [ImageDocument]
}

struct Meta: Codable, Equatable, Hashable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct ImageDocument: Codable, Equatable, Hashable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docURL: String
    let datetime: String
    var isLiked: Bool = false
    var orderIndex: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}

extension ImageDocument {
    init(localUser: RealmImageDocument) {
        self.collection = localUser.collection
        self.thumbnailURL = localUser.thumbnailURL
        self.imageURL = localUser.imageURL
        self.width = localUser.width
        self.height = localUser.height
        self.displaySitename = localUser.displaySitename
        self.docURL = localUser.docURL
        self.datetime = localUser.datetime
        self.isLiked = localUser.isLiked
        self.orderIndex = localUser.orderIndex
    }
}

struct VideoResponse: Codable, Equatable, Hashable {
    let meta: Meta
    let documents: [VideoDocument]
}

struct VideoDocument: Codable, Equatable, Hashable {
    let title: String
    let url: String
    let thumbnail: String
    let playTime: Int
    let datetime: String
    let author: String
    var isLiked: Bool = false
    var orderIndex: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case thumbnail
        case playTime = "play_time"
        case datetime
        case author
    }
}

extension VideoDocument {
    init(localUser: RealmVideoDocument) {
        self.title = localUser.title
        self.url = localUser.url
        self.thumbnail = localUser.thumbnail
        self.playTime = localUser.playTime
        self.datetime = localUser.datetime
        self.author = localUser.author
        self.isLiked = localUser.isLiked
        self.orderIndex = localUser.orderIndex
    }
}

