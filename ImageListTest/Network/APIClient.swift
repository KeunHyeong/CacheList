//
//  SearchClient.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Alamofire
import Foundation

class APIClient {
    static let agent = Agent()
    
    static let baseURL: URL = URL(string: "https://dapi.kakao.com/v2/search")!
}
