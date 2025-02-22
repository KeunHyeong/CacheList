//
//  SearchModel.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Combine
import Foundation
import SwiftUI

final class SearchModel: ObservableObject, SearchModelStateProtocol {
    @Published var metaIsEnd: Bool = false
    @Published var combinedItems: [SearchItem] = []
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    
    init() {
        setupSearchTextDebounce()
    }
}

extension SearchModel: SearchModelActionProtocol {
    private func setupSearchTextDebounce() {
        debouncedSearchText = self.searchText
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .assign(to: &$debouncedSearchText)
    }
    
    func updateMetaIsEnd(isEnd: Bool) {
        self.metaIsEnd = isEnd
    }
    
    func setCombinedItems(_ items: [SearchItem]) {
        print("uniqueItems count: \(items.count)")
        withAnimation(.easeInOut) {
            self.combinedItems = getSortedCombinedList(items)
        }
    }
    
//    func appendItems( imageResponse: ImageResponse, videoResponse: VideoResponse ) {
//        let imageItems = imageResponse.documents.map { SearchItem.image($0) }
//        let videoItems = videoResponse.documents.map { SearchItem.video($0) }
//        
//        var tempItems = self.combinedItems
//        tempItems.append(contentsOf: imageItems)
//        tempItems.append(contentsOf: videoItems)
//        
//        var seenIDs = Set<String>()
//        let uniqueItems = tempItems.filter { item in
//            if seenIDs.contains(item.id) {
//                return false
//            } else {
//                seenIDs.insert(item.id)
//                return true
//            }
//        }
//        
//        print("uniqueItems count: \(uniqueItems.count)")
//        withAnimation(.easeInOut) {
//            self.combinedItems = getSortedCombinedList(uniqueItems)
//        }
//    }
    
    //날짜순으로 정렬
    private func getSortedCombinedList(_ combinedList: [SearchItem]) -> [SearchItem] {
        let sortedList = combinedList.sorted { item1, item2 in
            guard let date1 = item1.datetime, let date2 = item2.datetime else { return false }
            return date1 > date2
        }
        
        return sortedList
    }
    
    func toggleList(for item: SearchItem) {
        if let index = combinedItems.firstIndex(where: {$0.id == item.id}) {
            combinedItems[index].toggleLike()
            
            if combinedItems[index].liked {
                RealmManager.shared.saveItem(combinedItems[index])
            }else{
                RealmManager.shared.deleteItem(combinedItems[index])
            }
        }
    }
    
    func cancel() {
        combinedItems = []
    }
}

extension SearchModel: SearchModelRouterProtocol {}

protocol SearchModelStateProtocol {
    var metaIsEnd: Bool { get set }
    var combinedItems: [SearchItem] { get }
    var searchText: String { get set }
    var debouncedSearchText: String { get set }
}

protocol SearchModelActionProtocol {
    func updateMetaIsEnd(isEnd: Bool)
//    func appendItems(imageResponse: ImageResponse, videoResponse: VideoResponse)
    func toggleList(for item: SearchItem)
    func setCombinedItems(_ items: [SearchItem])
    func cancel()
}

protocol SearchModelRouterProtocol {}
