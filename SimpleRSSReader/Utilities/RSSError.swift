//
//  RSSError.swift
//  SimpleRSSReader
//
//  Created by hyunho lee on 2021/07/12.
//

import Foundation

enum RSSError: String, Error {
    case invalidURL = "feed URL is invalid"
    case unableToComplete = "요청을 완료할 수 없습니다. 네트워크 연결을 확인해주세요."
    case invalidResponse = "유효하지 않은 서버로 부터의 응답입니다. 다시 요청해주세요."
    case invalidData = "서버로 받은 데이터가 유효하지 않습니다. 다시 요청해주세요."
}
