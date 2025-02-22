//
//  LocalIntent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation

class LocalIntent {
    private var actionsModel: LocalModelActionProtocol
    private var routerModel: LocalModelRouterProtocol
    
    init(model: LocalModelActionProtocol & LocalModelRouterProtocol) {
        actionsModel = model
        routerModel = model
    }
}

extension LocalIntent: LocalIntentProtocol {
    func fetchItems() {
        actionsModel.fetchLocalUsers()
    }
}

protocol LocalIntentProtocol {
    func fetchItems()
}
