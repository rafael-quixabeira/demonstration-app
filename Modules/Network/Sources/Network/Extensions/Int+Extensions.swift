//
//  Int+Extensions.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

extension Int {
    var seconds: TimeInterval { TimeInterval(self) }
    var minutes: TimeInterval { TimeInterval(self) * 60 }
    var hours:   TimeInterval { TimeInterval(self) * 3600 }
    var days:    TimeInterval { TimeInterval(self) * 86400 }
}
