//
//  MVIContainer.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import SwiftUI
import Combine

final class MVIContainer<Intent, Model>: ObservableObject {
    var intent: Intent
    var model: Model

    private var cancellable: Set<AnyCancellable> = []

    init(intent: Intent, model: Model, modelChangePublisher: ObjectWillChangePublisher) {
        self.intent = intent
        self.model = model

        modelChangePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellable)
    }
}
