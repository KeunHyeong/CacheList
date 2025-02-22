//
//  MainIntent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation
import SwiftUI

enum ViewType {
    case search, local
    
    var toTitle: String {
        switch self {
        case .search: return "Search"
        case .local: return "Local"
        }
    }
}

class MainIntent {
    private var actionsModel: MainModelActionProtocol
    private var routerModel: MainModelRouterProtocol
    
    init(model: MainModelActionProtocol & MainModelRouterProtocol) {
        actionsModel = model
        routerModel = model
    }
}

extension MainIntent: MainIntentProtocol {
    func updateSelectedTab(_ tab: ViewType){
        actionsModel.updateSelectedTab(tab)
    }
}

protocol MainIntentProtocol {
    func updateSelectedTab(_ tab: ViewType)
}
