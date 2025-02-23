//
//  LocalModel.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation

final class LocalModel: ObservableObject, LocalModelStateProtocol {
    @Published var combinedItems: [SearchItem] = []
    
    func fetchLocalUsers() {
        combinedItems = RealmManager.shared.fetchAllItems()
    }
}

extension LocalModel: LocalModelActionProtocol {}

protocol LocalModelStateProtocol {
    var combinedItems: [SearchItem] { get set }
}

protocol LocalModelActionProtocol {
    func fetchLocalUsers()
}
