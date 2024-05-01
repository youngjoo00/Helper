//
//  CheckedPostsKind.swift
//  Helper
//
//  Created by youngjoo on 4/29/24.
//

import Foundation

extension PostResponse.FetchPost {
    /**
     게시물 종류 확인
     - true: Feed
     - false: Help
     */
    var checkedPostsKind: Bool {
        return self.date.isEmpty ? true : false
    }
}
