//
//  SearchIntent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation

class SearchIntent {
    private var actionsModel: SearchModelActionProtocol
    private var routerModel: SearchModelRouterProtocol
    
    init(model: SearchModelActionProtocol & SearchModelRouterProtocol) {
        actionsModel = model
        routerModel = model
    }
}

extension SearchIntent: SearchIntentProtocol {
    func fetchData(keyword: String, page: Int) {
        Task {
            do {
                // 전체 SearchResult를 가져옵니다.
                let searchResult = try await SearchClient.fetchSearchResults(keyword: keyword, page: page)
                await MainActor.run {
                    // 캐시된 전체 결과의 items를 모델에 설정하고,
                    // meta 정보도 업데이트합니다.
                    
                    actionsModel.setCombinedItems(searchResult.items)
                    actionsModel.updateMetaIsEnd(isEnd: searchResult.meta.isEnd)
//                    actionsModel.updateMetaIsEnd(isEnd: searchResult.meta.isEnd)
                }
            } catch {
                print("Error fetching search results: \(error)")
            }
        }
    }
//    func fetchData(keyword: String, page: Int) {
//        Task {
//            do {
//                let images = try await SearchClient.fetchImages(keyword: keyword, page: page)
//                let videos = try await SearchClient.fetchVideos(keyword: keyword, page: page)
//                
//                await MainActor.run {
//                    actionsModel.appendItems(imageResponse: images, videoResponse: videos)
//                    actionsModel.updateMetaIsEnd(isEnd: images.meta.isEnd && videos.meta.isEnd)
//                }
//                
//            } catch {
//                print("error fetchMoreData")
//            }
//        }
//    }
    
    func toggleLike(for item: SearchItem) {
        actionsModel.toggleList(for: item)
    }
    
    func cancel() {
        actionsModel.cancel()
    }
}

protocol SearchIntentProtocol {
    func fetchData(keyword: String, page: Int)
    func toggleLike(for item: SearchItem)
    func cancel()
}
