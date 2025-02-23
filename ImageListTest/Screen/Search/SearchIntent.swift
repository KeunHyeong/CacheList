//
//  SearchIntent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation

class SearchIntent {
    private var actionsModel: SearchModelActionProtocol
    
    init(model: SearchModelActionProtocol) {
        actionsModel = model
    }
}

extension SearchIntent: SearchIntentProtocol {
    func fetchData(keyword: String, page: Int) {
        Task {
            do {
                let searchResult = try await SearchClient.fetchSearchResults(keyword: keyword, page: page)
                
                await MainActor.run {
                    actionsModel.setCombinedItems(searchResult.items)
                    actionsModel.updateMetaIsEnd(isEnd: searchResult.meta.isEnd)
                }
            } catch {
                print("Error SearchIntent fetchData: \(error)")
            }
        }
    }
    
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
