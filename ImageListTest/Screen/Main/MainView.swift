//
//  MainView.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var container: MVIContainer<MainIntentProtocol, MainModelStateProtocol>
    
    private var intent: MainIntentProtocol { container.intent }
    private var state: MainModelStateProtocol { container.model }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack(spacing:16) {
                    ForEach(Array(state.titles.enumerated()), id: \.offset) {_, tab in
                        Button {
                            intent.updateSelectedTab(tab)
                        }label: {
                            VStack {
                                Text(tab.toTitle)
                                    .frame(height: 54, alignment: .init(horizontal: .center, vertical: .bottom))
                                    .foregroundColor(state.selectedTab == tab ? Color.blue : Color.gray)
                                
                                Rectangle()
                                    .fill(state.selectedTab == tab ? Color.blue : .clear)
                                    .frame(height:2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
            
            Divider()
            
            TabView(selection: $container.model.selectedTab) {
                ForEach(Array(state.titles.enumerated()), id: \.offset) { _, type in
                    VStack {
                        switch type {
                        case .search:
                            SearchView.build()
                        case .local:
                            LocalView.build()
                        }
                    }
                    .tag(type)
                    .frame(maxHeight: .infinity)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

extension MainView {
    static func build() -> some View {
        let model = MainModel()
        let intent = MainIntent(model: model)
        let container = MVIContainer(
            intent: intent as MainIntentProtocol,
            model: model as MainModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        let view = MainView(container: container)
        return view
    }
}
