//
//  Agent.swift
//  ImageListTest
//
//  Created by 장근형 on 2/19/25.
//

import Alamofire
import Combine
import Foundation

struct Response<T> {
    let value: T
    let response: HTTPURLResponse
}

enum APIError: Error {
    case emptyResponse
    case unknown
    case http(ErrorData)
}

struct ErrorData: Decodable {
    let message: String
}

struct Agent {
    func run<T: Decodable>(_ request: DataRequest,
                           decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request
            .validate()
            .publishData(emptyResponseCodes: [200, 201, 204, 205])
            .tryMap { result -> Response<T> in
                if let req = result.request, let method = req.method, let url = req.url {
                    var log = "\(method.rawValue) \(url.path)"
                    if let query = url.query {
                        log += "?\(query)"
                    }
                    print("Request: \(log)")
                    if let bodyData = req.httpBody {
                        print("Request Body: \(String(decoding: bodyData, as: UTF8.self))")
                    }
                }
                
                if let error = result.error {
                    if let errorData = result.data {
                        do {
                            let errorInfo = try decoder.decode(ErrorData.self, from: errorData)
                            throw APIError.http(errorInfo)
                        } catch {
                            throw APIError.http(ErrorData(message: "에러 데이터 디코딩 실패: \(error.localizedDescription)"))
                        }
                    } else {
                        throw error
                    }
                }
                
                guard let data = result.data else {
                    throw APIError.emptyResponse
                }
                
                // JSON 전체를 T.self로 디코딩
                let decodedValue = try decoder.decode(T.self, from: data)
                guard let urlResponse = result.response else {
                    throw APIError.unknown
                }
                return Response(value: decodedValue, response: urlResponse)
            }
            .mapError { error -> APIError in
                return (error as? APIError) ?? .unknown
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
