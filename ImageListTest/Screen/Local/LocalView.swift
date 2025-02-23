//
//  LocalView.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import SwiftUI
import Kingfisher

struct LocalView: View {
    @StateObject var container: MVIContainer<LocalIntentProtocol, LocalModelStateProtocol>
    
    private var intent: LocalIntentProtocol { container.intent }
    private var state: LocalModelStateProtocol { container.model }
    
    var body: some View {
        VStack {
            ScrollView {
                LocalGridView(items: state.combinedItems)
            }
        }
        .onAppear {
            intent.fetchItems()
        }
    }
}

struct LocalGridView: View {
    var items:[SearchItem]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items.indices, id: \.self) { index in
                let item = self.items[index]
                LocalGridItemView(item: item)
            }
        }
    }
}

struct LocalGridItemView: View {
    var item: SearchItem
    
    var body: some View {
        ZStack(alignment: .trailing){
            KFImage(item.thumbnaiURL)
                .placeholder({ _ in
                    Image(systemName: "photo")
                })
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.5)
                .frame(width: item.width, height: item.height)
            
            Spacer()
            VStack(alignment:.trailing) {
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

extension LocalView {
    static func build() -> some View {
        let model = LocalModel()
        let intent = LocalIntent(model: model)
        let container = MVIContainer(
            intent: intent as LocalIntentProtocol,
            model: model as LocalModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = LocalView(container: container)
        return view
    }
}
