//
//  Task+Extensions.swift
//  Bipa
//
//  Created by Luiz Parreira on 21/06/22.
//  Copyright © 2022 Bipa. All rights reserved.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        try await Task.sleep(for: .seconds(seconds))
    }
}
