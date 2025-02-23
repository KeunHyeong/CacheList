//
//  MainIntent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Foundation
import SwiftUI

class MainIntent {
    private var actionsModel: MainModelActionProtocol
    
    init(model: MainModelActionProtocol) {
        actionsModel = model
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
