//
//  APIIntercepter.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Alamofire
import Foundation

final class APIInterceptor: RequestInterceptor {
    let apiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as! String
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest
        modifiedRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        modifiedRequest.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        completion(.success(modifiedRequest))
    }
}
