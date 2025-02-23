//
//  SearchResultCacheManager.swift
//  ImageListTest
//
//  Created by 장근형 on 2/22/25.
//

import Foundation

class SearchResultCacheManager {
    static let shared = NSCache<NSString, SearchResultCacheItem>()
    
    static func getPageIdx(_ keyword: String) -> Int {
        guard let item = SearchResultCacheManager.shared.object(forKey: keyword as NSString) else {
            return 1
        }
        return item.page
    }
}

struct SearchResult: Hashable, Equatable {
    let meta: Meta
    let items: [SearchItem]
}

class SearchResultCacheItem {
    let timestamp: Date
    let result: SearchResult
    var page: Int // 현재까지 캐싱된 페이지 번호
    
    init(result: SearchResult, page: Int) {
        self.timestamp = Date()
        self.result = result
        self.page = page
    }
}

