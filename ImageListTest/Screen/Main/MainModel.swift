//
//  MainModel.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation

final class MainModel: ObservableObject, MainModelStateProtocol {
    @Published var selectedTab: ViewType = .search
    @Published var titles: [ViewType] = [.search, .local]
}

extension MainModel: MainModelActionProtocol {
    func updateSelectedTab(_ selectedTab: ViewType) {
        self.selectedTab = selectedTab
    }
}

extension MainModel: MainModelRouterProtocol {}

protocol MainModelStateProtocol {
    var selectedTab: ViewType { get set }
    var titles: [ViewType] { get }
}

protocol MainModelActionProtocol {
    func updateSelectedTab(_ selectedTab: ViewType)
}

protocol MainModelRouterProtocol {}
