//
//  SearchClient.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Alamofire
import Foundation
import Combine

class SearchClient: APIClient {
    private static let searchCache = SearchResultCacheManager.shared
    
    static func fetchSearchResults(keyword: String, page: Int) async throws -> SearchResult {
        let cacheKey = keyword as NSString
        if let cachedItem = searchCache.object(forKey: cacheKey), Date().timeIntervalSince(cachedItem.timestamp) < 300 {
            // 기존 페이지 보다 작거나 같으면 캐싱된 데이타 반환
            if page <= cachedItem.page {
                return cachedItem.result
            } else {
                // 기존 페이지 보다 크다면 새 페이지 데이터를 받아 기존 결과에 추가
                let newImages = try await fetchImages(keyword: keyword, page: page)
                let newVideos = try await fetchVideos(keyword: keyword, page: page)
                
                let newItems: [SearchItem] = newImages.documents.map { SearchItem.image($0) } + newVideos.documents.map { SearchItem.video($0) }
                
                let combinedItems = cachedItem.result.items + newItems
                
                let combinedIsEnd = newImages.meta.isEnd && newVideos.meta.isEnd
                let updatedMeta = Meta(
                    totalCount: cachedItem.result.meta.totalCount,
                    pageableCount: cachedItem.result.meta.pageableCount,
                    isEnd: combinedIsEnd
                )
                let updatedResult = SearchResult(meta: updatedMeta, items: combinedItems)
                
                // 캐시 업데이트
                let newCacheItem = SearchResultCacheItem(result: updatedResult, page: page)
                searchCache.setObject(newCacheItem, forKey: cacheKey)
                
                return updatedResult
            }
        } else {
            // 캐시가 없거나 5분이 지난 경우, 첫 페이지 데이터를 새로 가져옴
            let images = try await fetchImages(keyword: keyword, page: 1)
            let videos = try await fetchVideos(keyword: keyword, page: 1)
            
            let items: [SearchItem] = images.documents.map { SearchItem.image($0) } + videos.documents.map { SearchItem.video($0) }
            
            let combinedIsEnd = images.meta.isEnd && videos.meta.isEnd
            
            let meta = Meta(
                totalCount: images.meta.totalCount,
                pageableCount: images.meta.pageableCount,
                isEnd: combinedIsEnd
            )
            let result = SearchResult(meta: meta, items: items)
            
            let newCacheItem = SearchResultCacheItem(result: result, page: page)
            searchCache.setObject(newCacheItem, forKey: cacheKey)
            
            return result
        }
    }
    
    static func fetchImages(keyword: String, page: Int = 1) async throws -> ImageResponse {
        let url = baseURL
            .appending(path: "image")
            .appending(queryItems: [URLQueryItem(name: "query", value: keyword)])
            .appending(queryItems: [URLQueryItem(name: "sort", value: "recency")])
            .appending(queryItems: [URLQueryItem(name: "page", value: String(page))])
            .appending(queryItems: [URLQueryItem(name: "size", value: "20")])
        
        let request = AF.request(url, interceptor: APIInterceptor())
        let publisher: AnyPublisher<Response<ImageResponse>, APIError> = agent.run(request)
        
        for try await responseWrapper in publisher.values {
            let result = responseWrapper.value
            return result
        }
        
        throw APIError.emptyResponse
    }
    
    static func fetchVideos(keyword: String, page: Int = 1) async throws -> VideoResponse {
        let url = baseURL
            .appending(path: "vclip")
            .appending(queryItems: [URLQueryItem(name: "query", value: keyword)])
            .appending(queryItems: [URLQueryItem(name: "sort", value: "recency")])
            .appending(queryItems: [URLQueryItem(name: "page", value: String(page))])
            .appending(queryItems: [URLQueryItem(name: "size", value: "20")])
        
        let request = AF.request(url, interceptor: APIInterceptor())
        
        let publisher: AnyPublisher<Response<VideoResponse>, APIError> = agent.run(request)
        
        for try await responseWrapper in publisher.values {
            let result = responseWrapper.value
            return result
        }
        
        throw APIError.emptyResponse
    }
}
