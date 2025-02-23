//
//  SearchView.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import SwiftUI
import Kingfisher
import Combine

struct SearchView: View {
    @StateObject var container: MVIContainer<SearchIntentProtocol, SearchModelStateProtocol>
    @State private var newText: String = ""
    @State private var isLoading: Bool = false
    @State private var page: Int = 1
    
    private var intent: SearchIntentProtocol { container.intent }
    private var state: SearchModelStateProtocol { container.model }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    GridView(
                        isEnd: state.metaIsEnd,
                        items: state.combinedItems,
                        loadMore: loadMoreData) { item in
                            intent.toggleLike(for: item)
                        }
                }
            }
            .searchable(text: $container.model.searchText, prompt: "검색어를 입력해주세요.")
            .navigationTitle("")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: state.debouncedSearchText) { newText in
            guard let _ = newText.first?.description else {
                intent.cancel()
                return
            }
            self.newText = newText
            page = SearchResultCacheManager.getPageIdx(newText)
            intent.fetchData(keyword: newText, page: page)
        }
    }
    
    private func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                page += 1
                intent.fetchData(keyword: self.newText, page: page)
                isLoading = false
            }
        }
    }
}

struct GridView: View {
    var isEnd: Bool
    var items:[SearchItem]
    var loadMore: () -> Void
    var toggleLike: (SearchItem) -> Void
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items.indices, id: \.self) { index in
                let item = self.items[index]
                GridItemView(item: item, toggleLike: {toggleLike(item)})
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: items)
            }
            
            if !items.isEmpty && !isEnd{
                HStack {
                    Spacer()
                    ProgressView()
                        .onAppear {
                            loadMore()
                        }
                    Spacer()
                }
                .frame(height: 40)
            }
        }
    }
}

struct GridItemView: View {
    var item: SearchItem
    var toggleLike: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing){
            KFImage(item.thumbnaiURL)
                .placeholder({ _ in
                    Image(systemName: "photo")
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.75)
                .frame(width: item.width, height: item.height)
            
            Spacer()
            
            VStack(alignment:.trailing) {
                Button(action: {
                    toggleLike()
                }) {
                    Image(systemName: item.liked ? "heart.fill" : "heart")
                        .foregroundColor(item.liked ? .red : .black)
                        .font(.system(size: 24))
                        .padding(8)
                }
                
                Spacer()
                
                HStack{
                    Text(item.dateString)
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .frame(width: 80, height: 30)
                }
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .background(Color.clear)
        }
    }
}

extension SearchView {
    static func build() -> some View {
        let model = SearchModel()
        let intent = SearchIntent(model: model)
        let container = MVIContainer(
            intent: intent as SearchIntentProtocol,
            model: model as SearchModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = SearchView(container: container)
        return view
    }
}
